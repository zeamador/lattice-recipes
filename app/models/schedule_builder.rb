# Public: A ScheduleBuilder wraps the rules of creating a schedule of Recipe
#         Steps. Its primary methods return false if the builder is left in an
#         invalid state as a result of some modification.
#
# Terminology:
#
# "Schedule"
#   A schedule is a set of steps scheduled to start at certain times. It is
#   represented as a Hash from Integer times, in minutes, to Sets of Steps that
#   start at that time. A valid schedule does not overuse focus or kitchen
#   resources at any time. If every prereq of every step in a schedule is also
#   in the schedule, the schedule is complete. A ScheduleBuilder only produces
#   valid schedules when operating in a defined state, but it can return
#   incomplete schedules. See schedule() and schedule_complete?() for more
#   information.
#
# "Preemption"
#   In this context refers to scheduling a step to end at some time other than
#   the current time. The purpose of this is to plan for a step's immediate
#   prerequisite by scheduling it to start at the next significant time.
#
# "Significant times"
#   Significant times are times at which any scheduled Step starts. They are
#   significant because when building a schedule backwards, Step start times
#   are when something about the schedule changes. There's no point attempting
#   to schedule steps at non-significant times because those times are always
#   functionally equivalent to exactly one significant time. Steps are
#   scheduled to end at significant times with the exception of preemptive
#   scheduling described below.
class ScheduleBuilder
  # A detailed explanation of how and why ScheduleBuilder works can be found in
  # the lattice-recipes repository in
  # docs/system_design/algorithm_explanation.md.

  def initialize(starting_steps, resources)
    @possible_steps = starting_steps
    @resources = resources
    @schedule = Hash.new
    # Invariant - @significant_times is the sorted keyset of @schedule
    @significant_times = SortedSet.new
    @current_time = 0
    @state = State.new
    # @pred_counts is a Hash from Steps to Integer pred counts. A Steps' pred
    # count is the number of unscheduled steps it is a prereq for. A Steps' pred
    # count is used to determine whether or not it can be added to
    # @possible_steps; only a step with a pred count of zero can be scheduled.
    # Invariant - A Step is never mapped to zero; instead, it is not a key at
    #             all. This allows us to quickly check whether or not any steps
    #             have pred counts greater than zero using empty?().
    populate_pred_counts(starting_steps)
  end

  # Public: This method overrides the default initialize_copy method. It is
  #         called automatically to initialize copies of this object returned
  #         from dup or clone.
  #
  # other - The ScheduleBuilder to be copied.
  #
  # Returns nothing.
  def initialize_copy(other)
    # Call the superclass's initialize_copy to perform a shallow-copy and
    # populate this ScheduleBuilder's fields.
    super
    # Deep clone mutable structures
    @possible_steps = @possible_steps.clone
    @resources = @resources.clone
    @schedule = @schedule.clone
    @schedule.keys.each do |time|
      @schedule[time] = @schedule[time].clone
    end
    @significant_times = @significant_times.clone
    @state = @state.clone
    @pred_counts = @pred_counts.clone
  end

  # Public: Add a step to the schedule being built such that the step ends at
  #         the current time. To be successfully added, the passed step must be
  #         in this ScheduleBuilder's list of possible steps and the step's
  #         required resources must be available at the current time.
  #
  # step - The Step to add to the schedule.
  #
  # Returns true if the step was successfully added, false otherwise.
  def add_step(step)
    # Check that the step is in @possible_steps and @resources can consume it.
    if(@possible_steps.include?(step) && @resources.consume(step))
      # Remove step from possible steps
      @possible_steps.delete(step)

      # Add step to this builder's state
      @state.steps << step

      # Add step to schedule
      start_time = @current_time + step.duration
      unless @significant_times.include?(start_time)
        # These lines must be paired to maintain @significant_time's invariant.
        # Note that concurrency can violate this invariant.
        @significant_times << start_time
        @schedule[start_time] = Set[]
      end
      @schedule[start_time] << step
      true
    else
      false
    end
  end

  # Public: Add the passed step to the schedule such that it starts at the next
  #         significant time in the schedule. From the perspective of the
  #         builder's mutating methods, but *not* its output schedules, the step
  #         starts at the next significant time and *ends at the current time*.
  #         Be careful about the order in which you make these calls; given the
  #         above information, add_step can return false seemingly incorrectly.
  #
  # step - The StepObject to add.
  #
  # Returns true if the step was successfully added, false otherwise
  def add_step_preemptive(step)
    # Explaining in precise terms why this method works as written is a lengthy
    # process, so it is not done here. The explanation is in the lattice-recipes
    # repository in docs/system_design/algorithm_explanation.md.

    old_current_time = @current_time

    next_time = get_next_time
    if next_time.nil?
      # There are no more significant times, so we can't schedule this step to
      # start at one. Return failure
      return false
    else
      # Set the current time such that if we schedule the step to end at it, the
      # step's start time will be the next significant time. This allows us to
      # reuse add_step and avoid redundant code.
      @current_time = next_time - step.duration
    end

    res = false
    unless @current_time <= old_current_time
      res = add_step(step)

      # add_step also adds the step to this builder's state, so remove it
      @state.steps.delete(step)

      # Now add the step to this builder's state's preemptive step map
      unless @state.preemptive_step_map.has_key?(@current_time)
        @state.preemptive_step_map[@current_time] = Set[]
      end

      @state.preemptive_step_map[@current_time] << step
    end

    @current_time = old_current_time
    res
  end

  # Public: Advances this ScheduleBuilder's current time to the next
  #         significant time in the schedule, moving backwards from the end. To
  #         successfully advance the current time, there must be a significant
  #         time to advance to and immediate prereqs of all steps starting at
  #         that time must be able to be scheduled. If successful, those
  #         immediate prereqs will be scheduled by this call. If unsuccessful,
  #         this call leaves the schedule builder in an UNDEFINED STATE.
  #
  # Examples
  #
  #   if builder.advance_current_time
  #     #continue building
  #   else
  #     #advancing current time failed, throw out this ScheduleBuilder
  #   end
  #
  # Returns true if the current time was successfully advanced, false otherwise.
  def advance_current_time
    @current_time = get_next_time

    if @current_time.nil?
      # There is not a next time to advance to; fail
      return false
    end

    # Reset this builder's state, because it only stores the state of the
    # builder between calls to advance_current_time.
    @state = State.new

    # Add all prereqs of steps that start at the new current time to possible
    # steps. @current_time is guaranteed to be a valid key in @schedule, because
    # it is invariantly non-nil by the above check and get_next_time guarantees
    # its return value to be nil or a valid key.
    @schedule[@current_time].each do |step|
      @resources.release(step)
      step.prereqs.each do |prereq|
        # This is a prereq of a now-scheduled step, so decrement the prereq's
        # pred count.
        @pred_counts[prereq] -= 1
        # If the pred count for the prereq is now zero, add it to possible steps
        # and delete its entry in the pred_counts hash.
        if @pred_counts[prereq] == 0
          @pred_counts.delete(prereq)
          @possible_steps << prereq
        end
      end
    end

    # Add all immediate prereqs. If any cannot be added, return false
    @schedule[@current_time].each do |step|
      unless step.immediate_prereq.nil? || add_step(step.immediate_prereq)
        return false
      end
    end

    true
  end

  # Public: Get the steps that can be scheduled to end at the current time in
  #         this ScheduleBuilder.
  #
  # Returns an Array of Steps. The returned Array is a clone; modifying it
  # doesn't change the internal state of this ScheduleBuilder.
  def possible_steps
    @possible_steps.clone
  end

  # Public: Get the schedule built so far by this ScheduleBuilder.
  #
  # Returns a Hash from Integer start times to Sets of Steps.
  def schedule
    max_time_from_end = @significant_times.to_a.last

    forward_schedule = Hash.new
    @schedule.each do |time_from_end, steps|
      # Clone step collection so that future calls to add_step don't modify the
      # data returned to a previous caller
      forward_schedule[max_time_from_end - time_from_end] = steps.clone
    end

    forward_schedule
  end

  # Public: Determine whether or not the schedule being built is complete, which
  #         means every step in the step dependency graph starting at the steps
  #         passed to the initializer have been scheduled.
  #
  # Returns true if the schedule being built is complete, false otherwise.
  def schedule_complete?
    @possible_steps.empty? && @pred_counts.empty?
  end

  def state
    @state.clone
  end

  private
  # Internal: Populate the @pred_counts Hash by mapping each step in the
  #           dependency tree defined by the passed starting_steps to the number
  #           of steps it is a prereq for.
  #
  # starting_steps - The Steps that define a dependency graph of Steps. These
  #                  steps must not be prerequisites for any other Step.
  #
  # Returns nothing.
  def populate_pred_counts(starting_steps)
    @pred_counts = Hash.new

    populate_pred_counts_helper(starting_steps)
  end

  # Internal: Helper method that looks through the passed steps' prereqs
  #           incrementing counts in @pred_counts and then recursively calls
  #           this method with steps' prereqs.
  #
  # steps - A Collection of Steps that define a dependency graph.
  #
  # Returns nothing.
  def populate_pred_counts_helper(steps)
    next_steps = Set[]
    steps.each do |step|
      step.prereqs.each do |prereq|
        next_steps << prereq
        if @pred_counts.has_key?(prereq)
          @pred_counts[prereq] += 1
        else
          @pred_counts[prereq] = 1
        end
      end
    end

    unless next_steps.empty?
      populate_pred_counts_helper(next_steps)
    end
  end

  # Internal: Get the next significant time in the schedule, which is the lowest
  #           time greater than the current time.
  #
  # Returns the next significant time in the schedule, or nil if there isn't
  # one. If non-nil, this value is guaranteed to be a key in @schedule
  def get_next_time
    # Advance an iterator over significant_times until we reach the current
    # time. If the current time is 0, it isn't in the list of significant times,
    # but the sorted set's first element will be the next significant time.
    e = @significant_times.each
    unless @current_time == 0
      until e.next == @current_time
      end
    end

    # The next element in the iterator is the next significant time to consider.
    # If there are no more elements, there are no more significant times, so
    # return false. Otherwise set the current time to the next significant
    # time.
    begin
      e.next
    rescue StopIteration
      nil
    end
  end

  # public: A State wraps the state of a ScheduleBuilder *since the last call to
  #         advance_current_time*. A builder's state is defined by all of the
  #         stpes that have been added to it since that call, as well as all the
  #         steps that have been added preemptively and when, exactly, they
  #         start. This allows users to determine whether or not two
  #         ScheduleBuilders are equivalent after a certain time.
  class State
    # Steps is a Set of Steps that have been added non-preemptively since the
    # last call to advance_current_time.
    attr_accessor :steps
    # Steps is a Hash from Integer end times to Steps preemptively scheduled to
    # end at those times since the last call to advance_current_time.
    attr_accessor :preemptive_step_map

    def initialize
      @steps = Set[]
      @preemptive_step_map = Hash.new
    end

    def initialize_copy(other)
      super
      @steps = @steps.clone
      @preemptive_step_map = @preemptive_step_map.clone
      @preemptive_step_map.keys.each do |time|
        @preemptive_step_map[time] = @preemptive_step_map[time].clone
      end
    end

    def eql?(other)
      @steps == other.steps && @preemptive_step_map == other.preemptive_step_map
    end

    def hash
      (@steps.hash * 11) ^ @preemptive_step_map.hash
    end
  end
end

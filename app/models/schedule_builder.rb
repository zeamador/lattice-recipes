class ScheduleBuilder
  def initialize(starting_steps, resources)
    @possible_steps = starting_steps
    @resources = resources
    @schedule = Hash.new
    # Invariant - @significant_times is the sorted keyset of @schedule
    @significant_times = SortedSet.new
    @current_time = 0
  end

  def initialize_copy(other)
    # Clone mutable structures
    super
    @possible_steps = @possible_steps.clone
    @resources = @resources.clone
    @schedule = @schedule.clone
    @significant_times = @significant_times.clone
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
    if(@possible_steps.include?(step) && @resources.consume(step))
      # Remove step from possible steps
      @possible_steps.delete(step)

      # Add step to schedule
      start_time = @current_time + step.time
      unless @significant_times.include?(start_time)
        # These lines must be paired to maintain @significant_time's invariant.
        # Note that concurrency can violate this invariant.
        @significant_times << start_time
        @schedule[start_time] = Array.new #Set?
      end
      @schedule[start_time] << step
      true
    else
      false
    end
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
  #     #advancing current time failed, fail or change something and try again
  #   end
  #
  # Returns true if the current time was successfully advanced, false otherwise.
  def advance_current_time
    # Advance an iterator over significant_times until we reach the current 
    # time. If the current time is 0, it isn't in the list of significant times,    # but the sorted set's first element will be the next significant time.
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
      @current_time = e.next
    rescue StopIteration
      return false
    end

    # We just iterated over @significant_times to find the new @current_time,
    # and @significant_times is invariantly the sorted keyset of @schedule, so
    # @current_time is guaranteed to be a valid key in @schedule.
    # Add all prereqs to possible steps.
    @schedule[@current_time].each do |step|
      @resources.release(step)
      step.prereqs.each do |prereq|
        unless has_unscheduled_descendant?(prereq)
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
  #         this ScheduleBuilder
  #
  # Returns an Array of Steps
  def possible_steps
    @possible_steps.clone
  end

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
    @possible_steps.empty? && (@current_time == @significant_times.to_a.last)
  end

  private
  # Internal: Check whether a step is a prerequisite for any other unscheduled
  #           steps.
  #
  # step - a Step object.
  #
  # Returns true if the step has unscheduled descendants, false otherwise
  def has_unscheduled_descendant?(step)
    has_unscheduled_descendant_helper(step, possible_steps)
  end

  # Internal: Check whether the passed step is in the step dependency graph
  #           passed as a set of its last steps.
  #
  # step - a Step object.
  # last_steps - a Set of the last steps of a step dependency graph.
  #
  # Returns true if the passed step is in the passed dependency graph, false
  # otherwise.
  def has_unscheduled_descendant_helper(step, last_steps)
    if (last_steps.empty?)
      false
    else
      next_last_steps = Set[]
      last_steps.each do |other_step|
        if step == other_step
          return true
        end

        other_step.prereqs.each do |prereq|
          next_last_steps << prereq
        end
      end

      has_unscheduled_descendant_helper(step, next_last_steps)
    end
  end
end


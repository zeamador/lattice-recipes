class ScheduleBuilder
  def initialize(starting_steps, resources)
    @possible_steps = starting_steps
    @resources = resources
    @schedule = Hash.new
    # Invariant - @significant_times is the sorted keyset of @schedule
    @significant_times = SortedSet.new
    @current_time = 0
  end

  # Public: Add a step to the schedule being built such that the step ends at 
  #         the current time. To be successfully added, the passed step must be
  #         in this ScheduleBuilder's list of possible steps and the step's 
  #         required resources must be available at the current time.
  #
  # step - The Step to add to the schedule. 
  #
  # Returns true if the step was successfully added, false otherwise.
  def add_step step
    if(@possible_steps.include?(step) && @resources.consume(step))
      # Remove step from possible steps
      possible_steps.delete(step)

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
    unless current_time == 0
      until e.next == current_time
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
      step.prereqs.each do |prereq|
        if prereq.pred_count == 0
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
    max_time_from_end = significant_times.first

    schedule = Hash.new
    @schedule.each do |time_from_end, steps|
      # Clone step collection so that future calls to add_step don't modify the
      # data returned to a previous caller
      schedule[max_time_from_end - time_from_end] = steps.clone
    end

    schedule
  end

  # Public: Determine whether or not the schedule being built is complete, which
  #         means every step in the step dependency graph starting at the steps
  #         passed to the initializer have been scheduled.
  #
  # Returns true if the schedule being built is complete, false otherwise.
  def schedule_complete?
    possible_steps.empty? && current_time == @significant_time.first
  end

  def deep_copy
    #TODO do this more efficiently
    Marshal.load(Marshal.dump(self))
  end
end


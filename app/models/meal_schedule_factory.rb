module MealScheduleFactory
  class << self
    # Public: Combine multiple recipes into a single meal, whose steps are an
    #         optimal combination of the steps of the input recipes, based
    #         optionally on a custom kitchen and an arbitrary number of cooks.
    #
    # recipes - An Array of Recipe objects representing recipes to combine
    # kitchen - A Kitchen object conveying the equipment available to use.
    #           Optional parameter, default KitchenObject.new.
    # num_users - The number of cooks who will be working. Optional parameter,
    #             default 1.
    #
    # Returns a MealSchedule
    def combine(recipes, kitchen=KitchenObject.new, num_users=1)
      # Combine final steps of each recipe into a single collection
      final_steps = [] #Set?
      recipes.each do |recipe|
        recipe.final_steps.each do |step|
          final_steps << step
        end
      end

      # Traverse the step dependency tree searching for steps that require
      # equipment that the kitchen does not have any of, and fail early if
      # found.
      steps_to_check = final_steps
      next_steps = Set[]
      until steps_to_check.empty?
        steps_to_check.each do |step|
          if !step.equipment.nil? && kitchen[step.equipment] == 0
            return MealSchedule.new(recipes, nil)
          end

          # Add all of the step's prereqs to the list of steps to check in the
          # next iteration.
          step.prereqs.each do |prereq|
            next_steps << prereq
          end
        end

        steps_to_check = next_steps
        next_steps = Set[]
      end

      resources = Resources.new(kitchen, num_users)
      schedule_builder = ScheduleBuilder.new(final_steps, resources)

      successful_schedule = create_meal_schedule_helper(schedule_builder, Set[])

      MealSchedule.new(recipes, successful_schedule)
    end

    private
    # Internal: Recursive method that performs the interleaving of recipe steps.
    #
    # schedule_builder - The ScheduleBuilder to which steps are added and
    #                    removed to create new schedules.
    # all_states_seen - A Set of ScheduleBuilder::State that have been seen in
    #                   this section of the algorithm, where sections are
    #                   separated by calls to
    #                   ScheduleBuilder.advance_current_time. This structure
    #                   allows the algorithm to ignore redundant branches; for
    #                   example, adding Step A then Step B is equivalent to
    #                   adding Step B then Step A as long as
    #                   advance_current_time is not called in between.
    #
    # Returns a Hash from Integer start times to Steps, which is the first
    # successful schedule found.
    def create_meal_schedule_helper(schedule_builder, all_states_seen)
      if redundant(schedule_builder, all_states_seen)
        # Base case - failure. Redundant branch.
        return nil
      elsif schedule_builder.schedule_complete?
        # Base case - success. This ScheduleBuilder has a complete schedule.
        return schedule_builder.schedule
      end

      schedule_builder.possible_steps.each do |step|
        # Make a copy of the schedule_builder to modify and pass to a new
        # recursive branch
        schedule_builder_copy = schedule_builder.clone

        if schedule_builder_copy.add_step(step)
          # Recursive case - add step
          schedule = create_meal_schedule_helper(schedule_builder_copy,
                                                   all_states_seen)
          unless schedule.nil?
            # Base case - success. Shortcircuiting upon discovery of first
            #             successful schedule.
            return schedule
          end
        end

        unless step.immediate_prereq.nil?
          # Make another copy for another recursive branch
          schedule_builder_copy = schedule_builder.clone

          if schedule_builder_copy.add_step_preemptive(step)
            # Recursive case - add preemptive step
            schedule = create_meal_schedule_helper(schedule_builder_copy,
                                                     all_states_seen)
            unless schedule.nil?
              # Base case - success. Shortcircuiting upon discovery of first
              #             successful schedule.
              return schedule
            end
          end
        end
      end

      schedule_builder_copy = schedule_builder.clone

      # A failed sweep line advance destroys the schedule builder copy, so don't
      # use it in else branches.
      if schedule_builder_copy.advance_current_time
        # Recursive case - advance sweep line
        schedule = create_meal_schedule_helper(schedule_builder_copy, Set[])

        unless schedule.nil?
          return schedule
        end
      else
        # Base case - failure. Unable to advance sweep line, but there are
        #             unscheduled steps.
        return nil
      end
    end

    # Internal: Checks to see if the passed builder's state is already in the
    #           passed Set of previously seen states. If it hasn't, adds the
    #           builder's state to the passed Set of seen states.
    #
    # builder - The ScheduleBuilder under question for being redundant.
    # seen - A Set of all States that have already been seen. The builder is
    #        redundant if this Set contains its state.
    #
    # Returns true if the builder's state is redundant given the seen states,
    # false otherwise.
    def redundant(builder, seen)
      state = builder.state

      # If the schedules seen so far includes the builder's schedule, the
      # builder is redundant
      is_redundant = seen.include?(state)

      unless is_redundant
        seen << state
      end

      is_redundant
    end
  end
end

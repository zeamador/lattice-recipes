module MealFactory
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
    # Returns a Meal
    def create_meal(recipes, kitchen=KitchenObject.new, num_users=1)
      # Combine final steps of each recipe into a single collection
      final_steps = [] #Set?
      recipes.each do |recipe|
        recipe.final_steps.each do |step|
          final_steps << step
        end
      end

      resources = Resources.new(kitchen, num_users)
      schedule_builder = ScheduleBuilder.new(final_steps, resources)
      successful_schedules = [] #Set?
    
      create_meal_helper(schedule_builder, successful_schedules)
      successful_schedules.uniq!      

      # Pick the schedule for which the end times of all of the final steps of
      # every recipe passed to this method end at closest to the same times.
      # This is calculated by minimizing the variance of the end times.
      best_schedules = nil
      lowest_mse = nil
      successful_schedules.each do |schedule|
        # Calculate the error for the schedule.
        mse = get_schedule_mse(schedule, final_steps)

        # Check if its error is less than or equal to the lowest error so far
        if lowest_mse.nil? || (mse < lowest_mse)
          # If lower, make a new list of best schedules containing only this 
          # one and note a new lowest error
          best_schedules = [schedule]
          lowest_mse = mse
        elsif lowest_mse == mse
          # If equal, add this schedule to the list of best schedules
          best_schedules << schedule
        end
      end      

      # Pick the shortest schedule of those with the same error
      best_schedule = nil
      best_schedule_length = nil
      best_schedules.each do |schedule|
        schedule_length = get_schedule_end_time(schedule)

        if best_schedule_length.nil? || (schedule_length < best_schedule_length)
          best_schedule = schedule
	  best_schedule_length = schedule_length
        end
      end

      MealObject.new(recipes, best_schedule)
    end

    private
    # Internal: Recursive method that performs the interleaving of recipe steps.
    #
    # schedule_builder - The ScheduleBuilder to which steps are added and 
    #                    removed to create new schedules.
    # successful_schedules - An Array of hashes from Integer end times to Steps.
    #                        Output parameter; this method populates it. Each
    #                        schedule is guaranteed to be a correct interleaving
    #                        of all of the steps in the schedule builder's step
    #                        dependency graph.
    #
    # Returns nothing, but populates successful_schedules.
    def create_meal_helper(schedule_builder, successful_schedules)
      schedule_builder.possible_steps.each do |step|
        # Make a copy of the schedule_builder to modify and pass to a new
        # recursive branch
        schedule_builder_copy = schedule_builder.clone   
        
        if schedule_builder_copy.add_step(step)
          # Recursive case - add step
          create_meal_helper(schedule_builder_copy, successful_schedules)
        end

        unless step.immediate_prereq.nil?
          # Make another copy for another recursive branch
          schedule_builder_copy = schedule_builder.clone

          if schedule_builder_copy.add_step_preemptive(step)
            create_meal_helper(schedule_builder_copy, successful_schedules)
          end
        end
      end

      schedule_builder_copy = schedule_builder.clone

      # A failed sweep line advance destroys the schedule builder copy, so don't
      # use it in else branches.
      if schedule_builder_copy.advance_current_time
        # Recursive case - advance sweep line
        create_meal_helper(schedule_builder_copy, successful_schedules)
      elsif schedule_builder.schedule_complete?
        # Base case - success
        successful_schedules << schedule_builder.schedule
        return # noop
      else
        # Base case - failure. Unable to advance sweep line, but there are steps
        #             remaining
        return # noop
      end
    end

    # Internal: Calculates the mean squared error of a schedule, where an error
    #           is the difference between a final step's end time and the end 
    #           time of a schedule.
    #
    # schedule - A Hash from Integer start times to Steps.
    # final_steps - The final Step objects in the schedule. Each of these steps
    #               must also be in the schedule.
    #
    # Returns the mean squared error of a schedule
    def get_schedule_mse(schedule, final_steps)
      # Construct a schedule with only the final steps.
      final_steps_schedule = Hash.new
      schedule.each do |time, steps|
        steps.each do |step|
          if final_steps.include?(step)
            unless final_steps_schedule.has_key?(time)
              final_steps_schedule[time] = []
            end

            final_steps_schedule[time] << step
          end
        end
      end

      # For each final step, find the difference between its end time and the
      # end time of the entire schedule. Sum the square of these differences.
      time_from_end_sq_sum = 0
      end_time = get_schedule_end_time(final_steps_schedule)

      final_steps_schedule.each do |time, steps|
        steps.each do |step|
          time_from_end = end_time - (time + step.time)
          time_from_end_sq_sum += time_from_end * time_from_end
        end
      end

      # Divide the sum by the number of final steps to get the mean squared 
      # error.
      Rational(time_from_end_sq_sum, final_steps.length)
    end

    # Internal: Calculate the time at which a step schedule ends.
    #
    # schedule - A Hash from Integer start times to Arrays of Steps.
    #
    # Returns the length of the given schedule.
    def get_schedule_end_time(schedule)
      schedule_end_time = 0
      schedule.each do |time, steps|
        # Find the longest step at each time
        longest_step_length = 0
        steps.each do |step|
          if step.time > longest_step_length
            longest_step_length = step.time
          end
        end

        # Add the longest step's length to the time to get a possible
        # schedule length
        end_time_candidate = time + longest_step_length
        if end_time_candidate > schedule_end_time
          schedule_end_time = end_time_candidate
        end
      end

      schedule_end_time
    end
  end
end

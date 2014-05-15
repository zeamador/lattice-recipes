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

      puts "\n#{successful_schedules.length}\n"

      # Pick the schedule for which the end times of all of the final steps of
      # every recipe passed to this method end at closest to the same times.
      # This is calculated by minimizing the variance of the end times.
      best_schedules = nil
      lowest_variance = nil
      successful_schedules.each do |schedule|
        # Construct a new schedule with only the final steps
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
        # Calculate the variance of the final steps' end times
        variance = end_time_variance(final_steps_schedule)

        if lowest_variance.nil? || (variance < lowest_variance)
          best_schedules = [schedule]
          lowest_variance = variance
        end

        if lowest_variance == variance
          best_schedules << schedule
        end
      end      

      # Pick the shortest schedule of those with the same variance
      best_schedule = nil
      best_schedule_length = nil
      best_schedules.each do |schedule|
        schedule_length = schedule_length(schedule)

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

    # Internal: Calculate the variance of the end times of all steps in a
    #           schedule. End time is a step's start time plus its duration.
    #
    # schedule - A Hash from integer start times to Steps
    #
    # Returns the variance of the end times of all steps in the schedule 
    def end_time_variance(schedule)
      # Calculate mean and squared mean
      num_steps = 0
      end_times_sum = 0
      end_times_sq_sum = 0
      schedule.each do |time, steps|
        steps.each do |step|
          num_steps += 1

          end_time = time + step.time
          end_times_sum += end_time
          end_times_sq_sum += end_time * end_time
        end
      end

      mean_of_squares = end_times_sq_sum.to_f / num_steps
      mean = end_times_sum.to_f / num_steps
      square_of_mean = mean * mean

      mean_of_squares - square_of_mean
    end

    # Internal: Calculate the total time a step schedule will take. Assumes the
    #           schedule's start time is zero.
    #
    # schedule - A Hash from Integer start times to Arrays of Steps.
    #
    # Returns the length of the given schedule.
    def schedule_length(schedule)
      schedule_length = 0
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
        possible_length = time + longest_step_length
        if possible_length > schedule_length
          schedule_length = possible_length
        end
      end

      schedule_length
    end
  end
end

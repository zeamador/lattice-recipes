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
      starting_steps = [] #Set?
      recipes.each do |recipe|
        recipe.final_steps.each do |step|
          starting_steps << step
        end
      end

      resources = Resources.new(kitchen, num_users)
      schedule_builder = ScheduleBuilder.new(starting_steps, resources)
      successful_schedules = [] #Set?
    
      create_meal_helper(schedule_builder, successful_schedules)

      # Pick the shortest schedule
      best_schedule = nil
      best_schedule_length = nil
      successful_schedules.each do |schedule|
        schedule_length = nil
        schedule.each_key do |time|
          if schedule_length.nil? || (time > schedule_length)
	    schedule_length = time
          end
        end

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
        # schedule_builder_copy = ScheduleBuilder.new(schedule_builder)
        schedule_builder_copy = schedule_builder.clone   
        
        if schedule_builder_copy.add_step(step)
          # Recursive case - add step
          create_meal_helper(schedule_builder_copy, successful_schedules)
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
  end
end

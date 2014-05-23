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

      resources = Resources.new(kitchen, num_users)
      schedule_builder = ScheduleBuilder.new(final_steps, resources)
    
      schedule = 
        create_meal_schedule_helper(schedule_builder)

      MealSchedule.new(recipes, schedule)
    end

    private
    # Internal: Recursive method that performs the interleaving of recipe steps.
    #
    # schedule_builder - The ScheduleBuilder to which steps are added and 
    #                    removed to create new schedules.
    #
    # Returns a successful schedule if possible, otherwise returns nil.
    def create_meal_schedule_helper(schedule_builder)
      schedule_builder.possible_steps.each do |step|
        # Make a copy of the schedule_builder to modify and pass to a new
        # recursive branch
        schedule_builder_copy = schedule_builder.clone   
        
        if schedule_builder_copy.add_step(step)
          schedule = create_meal_schedule_helper(schedule_builder_copy)

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
            schedule = create_meal_schedule_helper(schedule_builder_copy)
            
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
        schedule = create_meal_schedule_helper(schedule_builder_copy)

        unless schedule.nil?
          # Base case - success. Shortcircuiting upon discovery of first
          #             successful schedule.
          return schedule
        end
      elsif schedule_builder.schedule_complete?
        # Base case - success
        return schedule_builder.schedule
      else
        # Base case - failure. Unable to advance sweep line, but there are steps
        #             remaining
        return nil
      end
    end
  end
end

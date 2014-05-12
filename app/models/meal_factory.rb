class MealFactory
  def create_meal(recipes, kitchen=DEFAULT_KITCHEN, num_users=1)
    starting_steps = [] #Set?
    recipes.each do |recipe|
      recipe.final_steps.each do |step|
        starting_steps << step
      end
    end

    resources = Resources.new(kitchen, num_users)
    schedule_builder = ScheduleBuilder.new
    successful_schedules = [] #Set?
    
    create_meal_helper(starting_steps, schedule_builder, resources, 
                       successful_schedules)

    # PICK BEST SCHEDULE
    # RETURN BEST SCHEDULE
  end

  private
  def create_meal_helper(possible_steps, schedule_builder, resources, 
                         successful_schedules)
    possible_steps.each do |step|
      possible_steps_copy = possible_steps.clone
      schedule_builder_copy = schedule_builder.clone
      resources_copy = resources.clone      

      if add_step(step, possible_steps_copy, schedule_builder_copy, 
                  resources_copy)
        # Recursive case - add step
        create_meal_helper(possible_steps_copy, schedule_builder_copy, 
                           resources_copy, successful_schedules)
      end
    end

    possible_steps_copy = possible_steps.clone
    schedule_builder_copy = schedule_builder.clone
    resources_copy = resources.clone
    immediate_prereqs = []
    
    if advance_sweep_line(possible_steps_copy, schedule_builder_copy, 
                          resources_copy, immediate_prereqs
      # Recursive case - advance sweep line
      immediate_prereqs.each do |step|
        unless possible_steps_copy.include? step && 
               addStep(step, schedule_builder_copy, resources_copy)
          # Base case - failure. Unable to schedule immediate prereq
          return false
        end
      end

      create_meal_helper(possible_steps_copy, schedule_builder_copy, 
                         resources_copy, successful_schedules)
    elsif possible_steps.empty?
      # Base case - success
      successful_schedules << schedule_builder_copy.get_schedule
      return # noop
    else
      # Base case - failure. Unable to advance sweep line, but there are steps 
      #             remaining
      return # noop
    end
  end

  # Internal: Advance the sweep line of the schedule
  def advance_sweep_line(possible_steps, schedule_builder, resources,
                         immediate_prereqs)
    if schedule_builder.advance
      schedule_builder.starting_steps.each do |step|
        resources.release step

        step.prereqs.each do |prereq|
          if prereq.pred_count == 0
            possible_steps << prereq
          end
        end

        if step.immediate_prereq
          immediate_prereqs << step.immediate_prereq
        end
      end

      true
    else
      false #technically unnecessary - schedule_builder.advance will be false
    end
  end

  # Internal: Add a step to a schedule builder.
  #
  # step - The Step to be added.
  # possible_steps - The List of possible steps from which the step to be added
  #                  came.
  # schedule_builder - The ScheduleBuilder to add the step to.
  # resources - The Resources object to consult when trying to add the step.
  #
  # Returns true if the step was successfully added, false otherwise
  def add_step(step, possible_steps, schedule_builder, resources)
    if resources.consume step
      schedule_builder.add step
      possible_steps.delete step    

      true
    else
      false #technically unnecessary - resources.consume will be false
    end
  end
end

class MealFactory extend self
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

    # TODO apply metrics to pick best schedule
    MealObject.new(recipes, successful_schedules.first)
  end

  private
  # Internal: Recursive method that performs the interleaving of recipe steps.
  #
  # schedule_builder - The ScheduleBuilder to which steps are added and removed
  #                    to create new schedules.
  # successful_schedules - An Array of hashes from Integer end times to Steps.
  #                        Output parameter; this method populates it. Each
  #                        schedule is guaranteed to be a correct interleaving
  #                        of all of the steps in the schedule builder's step
  #                        dependency graph.
  #
  # Returns nothing, but populates successful_schedules.
  def create_meal_helper(schedule_builder, successful_schedules)
    schedule_builder.possible_steps.each do |step|
      schedule_builder_copy = schedule_builder.deep_copy   

      if schedule_builder_copy.add_step(step)
        # Recursive case - add step
        create_meal_helper(schedule_builder_copy, successful_schedules)
      end
    end

    schedule_builder_copy = schedule_builder.deep_copy
    
    # A failed sweep line advance destroys the schedule builder copy, so don't
    # use it in else branches.
    if schedule_builder_copy.advance_sweep_line
      # Recursive case - advance sweep line
      create_meal_helper(schedule_builder_copy, successful_schedules)
    elsif schedule_builder.possible_steps.empty?
      # Base case - success
      successful_schedules << schedule_builder.get_schedule
      return # noop
    else
      # Base case - failure. Unable to advance sweep line, but there are steps 
      #             remaining
      return # noop
    end
  end
end

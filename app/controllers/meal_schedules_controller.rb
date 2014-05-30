class MealSchedulesController < ApplicationController
  def show
    recipe_factory = RecipeFactory.new

    if current_user.meal.recipes.any?
      @recipe_objects = []
      current_user.meal.recipes.each do |db_recipe|
        @recipe_objects << recipe_factory.get_object_from_db_object(db_recipe)
      end

      kitchen_object = KitchenObject.new

      EquipmentTypes.constants.each do |constant|
        kitchen_object[constant] = 
          current_user.kitchen.send(constant.downcase)
      end

      @meal_schedule = 
        MealScheduleFactory.combine(@recipe_objects, kitchen_object, current_user.meal.cooks)
    end
  end
end

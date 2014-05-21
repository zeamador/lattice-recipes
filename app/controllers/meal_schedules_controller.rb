class MealSchedulesController < ApplicationController
  def show
    recipe_factory = RecipeFactory.new

    factory_params = Hash.new

    @recipe_objects = []
    current_user.recipes.each do |db_recipe|
      @recipe_objects << recipe_factory.get_object_from_db_object(db_recipe)
    end
    factory_params[:recipes] = @recipe_objects

    if true#current_user.has_key?(:kitchen)
      kitchen_object = KitchenObject.new
      
      EquipmentTypes.constants.each do |constant|
        kitchen_object[constant] = 
          current_user.kitchen.send(constant.downcase)
      end

      factory_params[:kitchen] = kitchen_object
    end

    if true#meal_schedule_params.has_key?(:num_users)
      factory_params[:num_users] = 1
    end

    @meal_schedule = MealScheduleFactory.combine(@recipe_objects)
  end
end

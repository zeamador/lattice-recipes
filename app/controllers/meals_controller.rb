class MealsController < ApplicationController

  def update
    @user = User.find(params[:id])
    @meal = @user.meal
    if @meal.update_attributes(meal_params)
      flash[:success] = "Meal updated!"
    end
    redirect_to @user
  end

  private

    def meal_params
      params.require(:meal).permit(:recipe_id)
    end

=begin
    def combine_recipes(db_recipes, db_kitchen, num_users=1)
      recipe_factory = RecipeFactory.new
      recipes = []

      db_recipes.each do |db_recipe|
        recipes << recipe_factory.get_recipe_from_db_object(db_recipe)
      end

      kitchen_factory = KitchenFactory.new
      kitchen = kitchen_factory.get_kitchen_from_db_object(db_kitchen)

      MealFactory.create_meal(recipes, kitchen, num_users)
    end
=end
end

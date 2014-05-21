class MealsController < ApplicationController

  def show
    @meal = Meal.find(params[:id])
  end

  private
  def meal_params
    params.require(:meal).permit(:recipe_id)
  end

end


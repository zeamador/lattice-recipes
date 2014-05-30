class MealsController < ApplicationController

  def show
    @meal = Meal.find(params[:id])
  end

  def update
    @meal = Meal.find(params[:id])
    @meal.update_attributes(meal_params)
    redirect_to :controller => 'meal_schedules', :action => 'show'
  end

  private
  def meal_params
    params.require(:meal).permit(:cooks)
  end

end


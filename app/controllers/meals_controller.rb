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
end


class MealsController < ApplicationController

  def new
    @meal = Meal.new
  end

  def show
    @meal = Meal.find(params[:id])
  end

  def update
    if @meal.update_attributes(meal_params)
      flash[:success] = "Meal updated"
      redirect_to @meal
    else
      render 'edit'
    end
  end

  private

    def meal_params
      params.require(:meal).permit(:recipe_id)
    end
end

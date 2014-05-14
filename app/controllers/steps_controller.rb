class StepsController < ApplicationController

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @step = @recipe.steps.create(step_params)
    redirect_to recipe_path(@recipe)
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    @step = @recipe.steps.find(params[:id])
    @step.destroy
    redirect_to recipe_path(@recipe)
  end

  private

    def step_params
      params.require(:step).permit(:description, :time, :attentiveness, 
                                   :step_number, :final_step)
    end
end

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
                                   :step_number, :final_step,
                                   step_mappers_attributes: [:id, 
                                                             :immediate_prereq,
                                                             :preheat_prereq,
                                                             :prereq_id,
                                                             :prereq_step_number])
    end
end

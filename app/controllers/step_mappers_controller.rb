class StepMappersController < ApplicationController

  def create
    @step = Step.find(params[:step_id])
    @step_mapper = @step.step_mappers.create(mapper_params)
    redirect_to recipe_path(@recipe)
  end

  private

    def mapper_params
      params.require(:step_mapper).permit(:immediate_prereq, :preheat_prereq,
                                          :prereq_step_number, :prereq_id)
    end
end

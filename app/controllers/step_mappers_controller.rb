class StepMappersController < ApplicationController

  private

    def mapper_params
      params.require(:step_mapper).permit(:immediate_prereq, :preheat_prereq,
                                          :prereq_step_number, :prereq_id)
    end
end

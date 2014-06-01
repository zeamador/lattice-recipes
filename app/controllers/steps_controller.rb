class StepsController < ApplicationController

  private

  def step_params
    params.require(:step).permit(:description, :duration, :attentiveness,
                                 :step_number, :final_step, :equipment,
                                 step_mappers_attributes: [:id,
                                                           :immediate_prereq,
                                                           :preheat_prereq,
                                                           :prereq_id,
                                                           :prereq_step_number])
  end
end

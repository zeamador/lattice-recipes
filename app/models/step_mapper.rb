class StepMapper < ActiveRecord::Base
  belongs_to :step

  validates :prereq_step_number, presence: true
end

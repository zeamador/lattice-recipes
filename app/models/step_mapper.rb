class StepMapper < ActiveRecord::Base
  belongs_to :step

  validates :prereq_step_number, numericality: {greater_than_or_equal_to: 1, less_than: :step_id}
end

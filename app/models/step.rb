class Step < ActiveRecord::Base
  belongs_to :recipe
  has_many :step_mappers, :dependent => :destroy
  accepts_nested_attributes_for :step_mappers, :reject_if =>
                                lambda { |a| a[:prereq_step_number].blank? },
                                :allow_destroy => true
end

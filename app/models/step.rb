class Step < ActiveRecord::Base
  has_one :equipment, :dependent => :destroy
  belongs_to :recipe
  has_many :step_mappers, :dependent => :destroy
  accepts_nested_attributes_for :step_mappers, :reject_if =>
    lambda { |a| a[:prereq_step_number].blank? },
  :allow_destroy => true
  accepts_nested_attributes_for :equipment, :allow_destroy => true
end

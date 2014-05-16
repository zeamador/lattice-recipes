class Step < ActiveRecord::Base
  has_one :equipment, :dependent => :destroy
  belongs_to :recipe
  has_many :step_mappers, :dependent => :destroy
  accepts_nested_attributes_for :step_mappers
  accepts_nested_attributes_for :equipment
end

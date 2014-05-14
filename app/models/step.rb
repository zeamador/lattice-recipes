class Step < ActiveRecord::Base
  belongs_to :equipment
  belongs_to :recipe
  has_many :step_mappers
end

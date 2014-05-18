class Step < ActiveRecord::Base
  belongs_to :recipe
  has_many :step_mappers, :dependent => :destroy
  accepts_nested_attributes_for :step_mappers,
                                :allow_destroy => true

  validates :description, presence: true
  validates :time, numericality: { greater_than_or_equal_to: 1 }
end

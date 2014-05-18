class Ingredient < ActiveRecord::Base
  belongs_to :recipe

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit, presence: true
  validates :description, presence: true
end

class Ingredient < ActiveRecord::Base
  belongs_to :recipe

  validates :quantity, numericality: { greater_than: 0 }
end

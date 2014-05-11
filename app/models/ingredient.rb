class Ingredient < ActiveRecord::Base
  belongs_to :recipe

  validates(:description, presence: true)
  validates(:quantity, presence: true)
  validates(:units, presence: true)
end

class Recipe < ActiveRecord::Base
  has_many :step
  has_many :ingredient
  belongs_to :user

  validates(:title, presence: true)
  validates(:ingredients, presence: true)
  validates(:final_steps, presence: true)
  validates(:tags, presence: true)
end

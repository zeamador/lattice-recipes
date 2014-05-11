class Meal < ActiveRecord::Base
  belongs_to :user
  has_many :recipe

  validates(:recipes, presence: true)
  validates(:schedule, presence: true)
end

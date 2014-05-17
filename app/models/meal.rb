class Meal < ActiveRecord::Base
  has_one :user
  has_many :recipes
end

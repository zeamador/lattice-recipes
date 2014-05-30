class Meal < ActiveRecord::Base
  has_one :user
  has_many :recipes

  validates :cooks, numericality: { greater_than_or_equal_to: 1 }
end

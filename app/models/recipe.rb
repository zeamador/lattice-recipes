class Recipe < ActiveRecord::Base
  has_many :steps
  has_many :ingredients
  belongs_to :user
end

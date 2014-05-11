# Immutable schedule of steps from multiple in recipes in a user's meal.
class MealObject
  attr_reader :recipes, :schedule

  # Public: Initialize a Meal with a set of recipes and a schedule of steps.
  #
  # recipes - Set of Recipe objects.
  # schedule - Hash from Integer times in minutes to Sets of Steps beginning 
  #            at that time.
  def initialize(recipes, schedule)
    @recipes = recipes
    @schedule = schedule
  end
end

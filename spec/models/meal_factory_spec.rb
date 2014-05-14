require 'spec_helper'

describe MealFactory do
  it "should produce a meal with a non-nil schedule" do
    step_a = StepObject.new("Bake pears", 20, 0, 1)
    pears = Set[IngredientObject.new("pears", 8, "whole")]
    recipe_a = RecipeObject.new(1, "Pears", pears, Set[step_a], false, nil)

    MealFactory.create_meal([recipe_a]).schedule.should_not be_nil
  end
  
  it "should schedule two steps at the same time to finish simultaneously" do
    step_a = StepObject.new("Bake pears", 20, 0, 1)
    pears = Set[IngredientObject.new("pears", 8, "whole")]
    recipe_a = RecipeObject.new(1, "Pears", pears, Set[step_a], false, nil)
    
    step_b = StepObject.new("Chop onions", 5, 2, 2)
    onions = Set[IngredientObject.new("onions", 2, "whole")]
    recipe_b = RecipeObject.new(2, "Onions", onions, Set[step_b], false, nil)
    
    expected = { 0 => [step_a], 15 => [step_b] }
    actual = MealFactory.create_meal([recipe_a, recipe_b]).schedule
    expect(actual).to eq(expected)
  end
end

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

  it "should schedule shorter final steps after longer ones" do
    step_a = StepObject.new("Peel potatos", 10, 2, 16)
    potatos = Set[IngredientObject.new("potatos", 8, "whole")]
    recipe_a = RecipeObject.new(16, "Potatos", potatos, Set[step_a], false, nil)
    
    step_b = StepObject.new("Chop onions", 5, 2, 2)
    onions = Set[IngredientObject.new("onions", 2, "whole")]
    recipe_b = RecipeObject.new(2, "Onions", onions, Set[step_b], false, nil)
    
    expected = { 0 => [step_a], 10 => [step_b] }
    actual = MealFactory.create_meal([recipe_b, recipe_a]).schedule
    expect(actual).to eq(expected)
  end

  it "should only schedule a step after its prereqs" do
    step_a = StepObject.new("Peel potatos", 10, 2, 16)
    step_b = StepObject.new("Bake potatos", 50, 0, 16, prereqs: [step_a])
    recipe = RecipeObject.new(16, "Potatos", nil, Set[step_b], false, nil)

    expected = { 0 => [step_a], 10 => [step_b] }
    actual = MealFactory.create_meal([recipe]).schedule
    expect(actual).to eq(expected)
  end

=begin
  it "should schedule steps as close to the end as possible" do
    step_a = StepObject.new("Make sauce", 10, 2, 9)
    step_b = StepObject.new("Rub sauce on steaks", 10, 2, 9, prereqs: [step_a])
    step_c = StepObject.new("Let stand for at least 30 mins", 30, 0, 9, 
                             prereqs: [step_b], immediate_prereq: step_b)
    step_d = StepObject.new("Grill steaks", 20, 2, 9, prereqs: [step_c])
    recipe_a = RecipeObject.new(9, "Steak", nil, Set[step_d], false, nil)

    step_e = StepObject.new("Mix ingredients", 5, 2, 20)
    step_f = StepObject.new("Bake", 120, 0, 20, prereqs: [step_e])
    step_g = StepObject.new("Let cool", 10, 0, 20, 
                             prereqs: [step_f], immediate_prereq: step_f)
    recipe_b = RecipeObject.new(20, "Stone Cake", nil, Set[step_g], false, nil)

    expected = { 0 => [step_e], 5 => [step_f], 65 => [step_a], 75 => [step_b],
      85 => [step_c], 115 => [step_d], 125 => [step_g] }
    actual = MealFactory.create_meal([recipe_a, recipe_b]).schedule

    expect(actual).to equal(expected)
=end
end

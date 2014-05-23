require 'spec_helper'

describe MealScheduleFactory do
  it "should produce a meal with a non-nil schedule" do
    step_a = StepObject.new("Bake pears", 20, 0, 1)
    recipe_a = RecipeObject.new(1, "Pears", "8 pears", Set[step_a])

    MealScheduleFactory.combine([recipe_a]).schedule.should_not be_nil
  end
  
  it "should schedule two steps at the same time to finish simultaneously" do
    step_a = StepObject.new("Bake pears", 20, 0, 1)
    recipe_a = RecipeObject.new(1, "Pears", "2 pears", Set[step_a])
    
    step_b = StepObject.new("Chop onions", 5, 2, 2)
    recipe_b = RecipeObject.new(2, "Onions", "onions", Set[step_b])
    
    expected = { 0 => Set[step_a], 15 => Set[step_b] }
    actual = MealScheduleFactory.combine([recipe_a, recipe_b]).schedule
    expect(actual).to eq(expected)
  end

  it "should schedule shorter final steps after longer ones" do
    step_a = StepObject.new("Peel potatos", 10, 2, 16)
    recipe_a = RecipeObject.new(16, "Potatos", "potatos", Set[step_a])
    
    step_b = StepObject.new("Chop onions", 5, 2, 2)
    recipe_b = RecipeObject.new(2, "Onions", "onions", Set[step_b])
    
    expected = { 0 => Set[step_a], 10 => Set[step_b] }
    actual = MealScheduleFactory.combine([recipe_b, recipe_a]).schedule
    expect(actual).to eq(expected)
  end

  it "should only schedule a step after its prereqs" do
    step_a = StepObject.new("Peel potatos", 10, 2, 16)
    step_b = StepObject.new("Bake potatos", 50, 0, 16, prereqs: [step_a])
    recipe = RecipeObject.new(16, "Potatos", nil, Set[step_b])

    expected = { 0 => Set[step_a], 10 => Set[step_b] }
    actual = MealScheduleFactory.combine([recipe]).schedule
    expect(actual).to eq(expected)
  end

  it "should schedule steps as close to the end as possible" do
    step_a = StepObject.new("Make sauce", 10, 2, 9)
    step_b = StepObject.new("Rub sauce on steaks", 10, 2, 9, prereqs: [step_a])
    step_c = StepObject.new("Let stand for at least 30 mins", 30, 0, 9, 
                             prereqs: [step_b], immediate_prereq: step_b)
    step_d = StepObject.new("Grill steaks", 20, 2, 9, prereqs: [step_c])
    recipe_a = RecipeObject.new(9, "Steak", nil, Set[step_d])

    step_e = StepObject.new("Mix ingredients", 5, 2, 20)
    step_f = StepObject.new("Bake", 120, 0, 20, prereqs: [step_e])
    step_g = StepObject.new("Let cool", 10, 0, 20, 
                             prereqs: [step_f], immediate_prereq: step_f)
    recipe_b = RecipeObject.new(20, "Stone Cake", nil, Set[step_g])

    expected = { 0 => Set[step_e], 5 => Set[step_f], 65 => Set[step_a], 
                 75 => Set[step_b], 85 => Set[step_c], 115 => Set[step_d], 
                 125 => Set[step_g] }
    actual = MealScheduleFactory.combine([recipe_a, recipe_b]).schedule

    expect(actual).to eq(expected)
  end

  it "should start steps of different length simultaneously when appropriate" do
    step_a = StepObject.new("Step A", 15, 2, 12)
    recipe_a = RecipeObject.new(12, "Recipe A", nil, Set[step_a])

    step_b = StepObject.new("Step B", 50, 1, 90)
    step_c = StepObject.new("Step C", 5, 0, 90, 
                            prereqs: [step_b], immediate_prereq: step_b)
    recipe_b = RecipeObject.new(90, "Recipe B", nil, Set[step_c])

    expected = { 0 => Set[step_b], 50 => Set[step_a, step_c] }
    actual = MealScheduleFactory.combine([recipe_a, recipe_b]).schedule
    expect(actual).to eq(expected)
  end

  it "should not allow the oven to be re-preheated before being used" do
    step_1a = StepObject.new("Preheat 1", 30, 0, 1, equipment: :OVEN)
    step_1b = StepObject.new("Use preheat 1", 5, 0, 1, equipment: :OVEN,
                               prereqs: Set[step_1a], preheat_prereq: step_1a)
      
    step_2a = StepObject.new("Preheat 2", 35, 0, 2, equipment: :OVEN)
    step_2b = StepObject.new("Use preheat 2", 10, 0, 2, equipment: :OVEN,
                               prereqs: Set[step_2a], preheat_prereq: step_2a)

    recipe_1 = RecipeObject.new(1, "Recipe 1", nil, Set[step_1b])
    recipe_2 = RecipeObject.new(2, "Recipe 2", nil, Set[step_2b])
      
    expected = { 0 => Set[step_2a], 35 => Set[step_2b], 45 => Set[step_1a], 
                75 => Set[step_1b] }
    actual = MealScheduleFactory.combine([recipe_1, recipe_2]).schedule

    expect(actual).to eq(expected)
  end

  it "should not duplicate steps" do
    step_a = StepObject.new("Step A", 1, 2, 123)
    step_b = StepObject.new("Step B", 1, 2, 123)
    step_c = StepObject.new("Step C", 1, 2, 123)
    step_d = StepObject.new("Step D", 1, 0, 123, prereqs: Set[step_c])
    recipe = RecipeObject.new(123, "Recipe", nil, Set[step_a, step_b, step_d])

    expected = [step_a, step_b, step_c, step_d]

    schedule = MealScheduleFactory.combine([recipe]).schedule
    actual = []
    schedule.each do |time, steps|
      actual += steps.to_a
    end

    expect(actual).to match_array(expected)
  end
end


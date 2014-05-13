require 'spec_helper'

describe RecipeObject do
  it "should be secret if marked as secret" do
    sugar = IngredientObject.new("sugar", 2, "cups")
    step = StepObject.new("Buy cookies", 120, 1, 1234)
    recipe = RecipeObject.new(1234, "Cookies", Set[sugar], Set[step], true, nil)
    recipe.should be_secret
  end

  it "should not be secret if marked as public" do
    sugar = IngredientObject.new("sugar", 2, "cups")
    step = StepObject.new("Buy cookies", 120, 1, 1234)
    recipe = RecipeObject.new(1234, "Cookies", Set[sugar], Set[step], false, nil)
    recipe.should_not be_secret
  end

  it "should not have an empty set of final steps" do
    sugar = IngredientObject.new("sugar", 2, "cups")
    expect { RecipeObject.new(1234, "Cookies", 
                              Set[sugar], Set[], false, nil) }.to raise_error(
        "Set of final steps must contain at least one step")
    end

  it "should not have a nil set of final steps" do
    sugar = IngredientObject.new("sugar", 2, "cups")
    expect { RecipeObject.new(1234, "Cookies", 
                              Set[sugar], nil, false, nil) }.to raise_error(
        "Set of final steps must contain at least one step")
    end
end
 

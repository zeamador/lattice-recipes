require 'spec_helper'

describe RecipeObject do
   it "should not have an empty set of final steps" do
    sugar = IngredientObject.new("sugar", 2, "cups")
    expect { RecipeObject.new(1234, "Cookies", Set[sugar], Set[]) 
           }.to raise_error("Set of final steps must contain at least one step")
    end

  it "should not have a nil set of final steps" do
    sugar = IngredientObject.new("sugar", 2, "cups")
    expect { RecipeObject.new(1234, "Cookies", Set[sugar], nil) 
           }.to raise_error("Set of final steps must contain at least one step")
    end
end
 

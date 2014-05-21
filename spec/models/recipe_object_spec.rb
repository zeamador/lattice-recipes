require 'spec_helper'

describe RecipeObject do
   it "should not have an empty set of final steps" do
    expect { RecipeObject.new(1234, "Cookies", "sugar", Set[]) 
           }.to raise_error("Set of final steps must contain at least one step")
    end

  it "should not have a nil set of final steps" do
     expect { RecipeObject.new(1234, "Cookies", "sugar", nil) 
           }.to raise_error("Set of final steps must contain at least one step")
    end
end
 

require 'spec_helper'

describe IngredientObject do
  it "should have three readable fields" do
    ingredient = IngredientObject.new("flour", 4, "cups")
    expect(ingredient.description).to eq("flour")
    expect(ingredient.quantity).to eq(4)
    expect(ingredient.unit).to eq("cups")
  end

  it "should be immutable" do
    ingredient = IngredientObject.new("flour", 4, "cups")
    expect {ingredient.description = "sugar" }.to raise_error(NoMethodError)
    expect {ingredient.quantity = 7 }.to raise_error(NoMethodError)
    expect {ingredient.unit = "pounds" }.to raise_error(NoMethodError)
  end
end

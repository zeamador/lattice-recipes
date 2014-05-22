require 'spec_helper'

describe Resources do
  it "should allow a step's equipment to be consumed if available" do
    kitchen = KitchenObject.new
    kitchen[:OVEN] = 1
    resources = Resources.new(kitchen, 1)
    step = StepObject.new("Bake pizza", 10, 0, 123, equipment: :OVEN)
    resources.consume(step).should be_true
  end

  it "should not allow a step's equipment to be consumed if not available" do
    kitchen = KitchenObject.new
    kitchen[:OVEN] = 0
    resources = Resources.new(kitchen, 1)
    step = StepObject.new("Bake pizza", 10, 0, 123, equipment: :OVEN)
    resources.consume(step).should be_false
  end

  it "should not allow equipment to be consumed if already in use" do
    kitchen = KitchenObject.new
    kitchen[:OVEN] = 1
    resources = Resources.new(kitchen, 1)
    step_1 = StepObject.new("Bake pizza", 10, 0, 123, equipment: :OVEN)
    step_2 = StepObject.new("Bake potatoes", 30, 0, 123, equipment: :OVEN)
    resources.consume(step_1).should be_true
    resources.consume(step_2).should be_false
  end

  it "should allow resources to be consumed after being released" do
    kitchen = KitchenObject.new
    kitchen[:OVEN] = 1
    resources = Resources.new(kitchen, 1)
    step_1 = StepObject.new("Bake pizza", 10, 0, 123, equipment: :OVEN)
    step_2 = StepObject.new("Bake potatoes", 30, 0, 123, equipment: :OVEN)
    resources.consume(step_1).should be_true
    resources.release(step_1)
    resources.consume(step_2).should be_true
  end

  it "should not allow too much attentiveness to be consumed" do
    resources = Resources.new(KitchenObject.new, 1)
    step_1 = StepObject.new("Chop chop chop", 10, 2, 123)
    step_2 = StepObject.new("Choppity chop", 30, 2, 123)
    resources.consume(step_1).should be_true
    resources.consume(step_2).should be_false
  end

  it "one user should be able to consume at most 2 units of attention" do
    resources = Resources.new(KitchenObject.new, 1)
    step_stir_1 = StepObject.new("Stir 1", 10, 1, 123)
    step_stir_2 = StepObject.new("Stir 2", 10, 1, 123)
    step_stir_3 = StepObject.new("Stir 3", 10, 1, 123)
    step_boil = StepObject.new("Boil water", 10, 0, 123)
    resources.consume(step_stir_1).should be_true
    resources.consume(step_stir_2).should be_true
    resources.consume(step_stir_3).should be_false
    resources.consume(step_boil).should be_true
  end

  it "two users should be able to consume at most 4 units of attention" do
    step_chop_1 = StepObject.new("Choppity chop", 10, 2, 123)
    step_stir_1 = StepObject.new("Stir 1", 20, 1, 123)
    step_stir_2 = StepObject.new("Stir 2", 30, 1, 123)
    step_chop_2 = StepObject.new("Chop chop chop", 5, 2, 123)
    step_boil = StepObject.new("Boil water", 20, 0, 123)

    resources = Resources.new(KitchenObject.new, 2)
    resources.consume(step_chop_1).should be_true
    resources.consume(step_stir_1).should be_true
    resources.consume(step_chop_2).should be_false

    resources = Resources.new(KitchenObject.new, 2)
    resources.consume(step_chop_1).should be_true
    resources.consume(step_stir_1).should be_true
    resources.consume(step_stir_2).should be_true
    resources.consume(step_boil).should be_true
    resources.consume(step_chop_2).should be_false
  end

  it "should be immune from downstream changes after being cloned" do
    step_a = StepObject.new("Step A", 1, 2, 123)
    step_b = StepObject.new("Step B", 1, 2, 123)
    resources = Resources.new(KitchenObject.new, 1)
    expect(resources.consume(step_a)).to be_true

    resources_copy = resources.clone
    resources_copy.release(step_a)

    expect(resources.consume(step_b)).to be_false
  end
end

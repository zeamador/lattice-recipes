require 'spec_helper'

describe Resources do
  it "should allow a step's equipment to be consumed if available" do
    kitchen = KitchenObject.new
    kitchen[:OVEN] = 1
    resources = Resources.new(kitchen, 1)
    step = StepObject.new("Bake pizza", 10, :NONE, 123, equipment: :OVEN)
    resources.consume(step).should be_true
  end

  it "should not allow a step's equipment to be consumed if not available" do
    kitchen = KitchenObject.new
    kitchen[:OVEN] = 0
    resources = Resources.new(kitchen, 1)
    step = StepObject.new("Bake pizza", 10, :NONE, 123, equipment: :OVEN)
    resources.consume(step).should be_false
  end

  it "should not allow equipment to be consumed if already in use" do
    kitchen = KitchenObject.new
    kitchen[:OVEN] = 1
    resources = Resources.new(kitchen, 1)
    step_1 = StepObject.new("Bake pizza", 10, :NONE, 123, equipment: :OVEN)
    step_2 = StepObject.new("Bake potatoes", 30, :NONE, 123, equipment: :OVEN)
    resources.consume(step_1).should be_true
    resources.consume(step_2).should be_false
  end

  it "should allow resources to be consumed after being released" do
    kitchen = KitchenObject.new
    kitchen[:OVEN] = 1
    resources = Resources.new(kitchen, 1)
    step_1 = StepObject.new("Bake pizza", 10, :NONE, 123, equipment: :OVEN)
    step_2 = StepObject.new("Bake potatoes", 30, :NONE, 123, equipment: :OVEN)
    resources.consume(step_1).should be_true
    resources.release(step_1)
    resources.consume(step_2).should be_true
  end

  it "should not allow too much attentiveness to be consumed" do
    resources = Resources.new(KitchenObject.new, 1)
    step_1 = StepObject.new("Chop chop chop", 10, :ALL, 123)
    step_2 = StepObject.new("Choppity chop", 30, :ALL, 123)
    resources.consume(step_1).should be_true
    resources.consume(step_2).should be_false
  end

  it "one user should be able to consume at most 3 units of attention" do
    resources = Resources.new(KitchenObject.new, 1)
    step_stir_1 = StepObject.new("Stir 1", 10, :SOME, 123)
    step_stir_2 = StepObject.new("Stir 2", 10, :SOME, 123)
    step_stir_3 = StepObject.new("Stir 3", 10, :SOME, 123)
    step_stir_4 = StepObject.new("Stir 4", 10, :SOME, 123)
    step_boil = StepObject.new("Boil water", 10, :NONE, 123)
    resources.consume(step_stir_1).should be_true
    resources.consume(step_stir_2).should be_true
    resources.consume(step_stir_3).should be_true
    resources.consume(step_stir_4).should be_false
    resources.consume(step_boil).should be_true
  end

  it "two users should be able to consume at most 6 units of attention" do
    step_chop_1 = StepObject.new("Choppity chop", 10, :ALL, 123)
    step_stir_1 = StepObject.new("Stir 1", 20, :SOME, 123)
    step_stir_2 = StepObject.new("Stir 2", 30, :SOME, 123)
    step_chop_2 = StepObject.new("Chop chop", 5, :ALL, 123)
    step_chop_3 = StepObject.new("Chop chop chop", 5, :ALL, 123)
    step_boil = StepObject.new("Boil water", 20, :NONE, 123)

    resources = Resources.new(KitchenObject.new, 2)
    resources.consume(step_chop_1).should be_true
    resources.consume(step_stir_1).should be_true
    resources.consume(step_chop_2).should be_true
    resources.consume(step_chop_3).should be_false

    resources = Resources.new(KitchenObject.new, 2)
    resources.consume(step_chop_1).should be_true
    resources.consume(step_chop_2).should be_true
    resources.consume(step_chop_3).should be_true
    resources.consume(step_boil).should be_true
    resources.consume(step_chop_2).should be_false
  end

  it "should be immune from downstream focus changes after being cloned" do
    step_a = StepObject.new("Step A", 1, :ALL, 123)
    step_b = StepObject.new("Step B", 1, :ALL, 123)
    resources = Resources.new(KitchenObject.new, 1)
    expect(resources.consume(step_a)).to be_true

    resources_copy = resources.clone
    resources_copy.release(step_a)

    expect(resources.consume(step_b)).to be_false
  end

  it "should be immune from downstream equipment changes after being cloned" do
    step_a = StepObject.new("Step A", 1, :ALL, 123, equipment: :TOASTER)
    step_b = StepObject.new("Step B", 1, :ALL, 123, equipment: :TOASTER)
    resources = Resources.new(KitchenObject.new, 1)

    resources_copy = resources.clone
    resources_copy.consume(step_a)

    expect(resources.consume(step_b)).to be_true
  end

  it "should allow multiple ovens to be used simultaneously" do
    # When reading this test, keep in mind that the logic in Resources assumes
    # steps are consumed in reverse order.

    # Control case, expect to fail
    kitchen = KitchenObject.new
    resources = Resources.new(kitchen, 1)

    step_a1 = StepObject.new("Preheat oven", 1, :NONE, 123, equipment: :OVEN)
    step_a2 = StepObject.new("Use oven", 1, :NONE, 123, equipment: :OVEN,
                             prereqs: [step_a1], preheat_prereq: step_a1)
    step_b1 = StepObject.new("Preheat oven", 1, :NONE, 234, equipment: :OVEN)
    step_b2 = StepObject.new("Use oven", 1, :NONE, 234, equipment: :OVEN,
                             prereqs: [step_b1], preheat_prereq: step_b1)
    # Start using A
    resources.consume(step_a2).should be_true
    # Finish using A
    resources.release(step_a2).should be_true
    # Start using B
    resources.consume(step_b2).should be_false

    # Test case, expect to succeed
    kitchen[:OVEN] = 2
    resources = Resources.new(kitchen, 1)

    # Start using A
    resources.consume(step_a2).should be_true
    # Start using B
    resources.consume(step_b2).should be_true
    # Finish using A
    resources.release(step_a2).should be_true
    # Finish using B
    resources.release(step_b2).should be_true
    # Start preheating A
    resources.consume(step_a1).should be_true
    # Finish preheating A
    resources.release(step_a1).should be_true
    # Start preheating B
    resources.consume(step_b1).should be_true
    # Finish preheating B
    resources.release(step_b1).should be_true
  end
end

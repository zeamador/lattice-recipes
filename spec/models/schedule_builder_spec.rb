require 'spec_helper'

describe ScheduleBuilder do
  it "should be complete after adding only step and advancing the time" do
    resources = Resources.new(KitchenObject.new, 1)
    step = StepObject.new("Cut apples", 10, :ALL, 170)
    builder = ScheduleBuilder.new([step], resources)
    builder.add_step(step).should be_true
    builder.advance_current_time.should be_true
    builder.should be_schedule_complete
    builder.advance_current_time.should be_false
  end

  it "should fail to add a step when there is not enough focus for it" do
    resources = Resources.new(KitchenObject.new, 1)
    step_a = StepObject.new("Cut apples", 10, :ALL, 170)
    step_b = StepObject.new("Cut bananas", 6, :ALL, 170)
    builder = ScheduleBuilder.new([step_a, step_b], resources)
    builder.add_step(step_a).should be_true
    builder.add_step(step_b).should be_false
  end

  it "should free up attention when step finishes" do
    resources = Resources.new(KitchenObject.new, 1)
    step_a = StepObject.new("Cut apples", 10, :ALL, 170)
    step_b = StepObject.new("Cut bananas", 6, :ALL, 170)
    builder = ScheduleBuilder.new([step_a, step_b], resources)
    builder.add_step(step_a).should be_true
    builder.advance_current_time.should be_true
    builder.add_step(step_b).should be_true
  end

  it "should fail to add a step when there are not enough resouces for it" do
    resources = Resources.new(KitchenObject.new, 1)
    step_a = StepObject.new("Bake apples", 10, :NONE, 170, equipment: :OVEN)
    step_b = StepObject.new("Bake bananas", 20, :NONE, 170, equipment: :OVEN)
    builder = ScheduleBuilder.new([step_a, step_b], resources)
    builder.add_step(step_a).should be_true
    builder.add_step(step_b).should be_false
  end

  it "should free up resources when a step is finished with them" do
    resources = Resources.new(KitchenObject.new, 1)
    step_a = StepObject.new("Bake apples", 10, :NONE, 170, equipment: :OVEN)
    step_b = StepObject.new("Bake bananas", 20, :NONE, 170, equipment: :OVEN)
    builder = ScheduleBuilder.new([step_a, step_b], resources)
    builder.add_step(step_a).should be_true
    builder.advance_current_time.should be_true
    builder.add_step(step_b).should be_true
  end

  it "should be able to add no attention steps during a full attention step" do
    resources = Resources.new(KitchenObject.new, 1)
    step_a = StepObject.new("Cut apples", 10, :ALL, 170)
    step_b = StepObject.new("Boil water", 12, :NONE, 170)
    step_c = StepObject.new("Preheat oven", 8, :NONE, 220)
    builder = ScheduleBuilder.new([step_a, step_b, step_c], resources)
    builder.add_step(step_a).should be_true
    builder.add_step(step_b).should be_true
    builder.add_step(step_c).should be_true
  end

  it "should be able to add two some attention steps at the same time" do
    resources = Resources.new(KitchenObject.new, 1)
    step_a = StepObject.new("Stir apples periodically", 10, :SOME, 170)
    step_b = StepObject.new("Stir bananas periodically", 12, :SOME, 170)
    builder = ScheduleBuilder.new([step_a, step_b], resources)
    builder.add_step(step_a).should be_true
    builder.add_step(step_b).should be_true
  end

  it "should be immune from downstream changes after being cloned" do
    resources = Resources.new(KitchenObject.new, 1)
    step_a = StepObject.new("Step A", 1, :ALL, 123)
    step_b = StepObject.new("Step B", 1, :ALL, 123)

    builder = ScheduleBuilder.new([step_a, step_b], resources)
    builder.add_step(step_a).should be_true

    builder_copy = builder.clone
    builder_copy.advance_current_time.should be_true
    builder_copy.add_step(step_b).should be_true

    builder.possible_steps.should_not include step_a
    builder.advance_current_time.should be_true
    builder.add_step(step_b).should be_true

    expected = [step_a, step_b]
    actual = []
    builder.schedule.values.each do |steps|
      actual += steps.to_a
    end
    expect(actual).to match_array(expected)
  end

  it "should always allow steps to be scheduled sequentially" do
    resources = Resources.new(KitchenObject.new, 1)
    step_a1 = StepObject.new("Step A1", 5, :ALL, 123)
    step_a2 = StepObject.new("Step A2", 5, :ALL, 123, equipment: :BURNER,
                             prereqs: Set[step_a1], immediate_prereq: step_a1)
    step_a3 = StepObject.new("Step A3", 5, :ALL, 123)

    step_b1 = StepObject.new("Step B1", 5, :ALL, 456)
    step_b2 = StepObject.new("Step B2", 5, :ALL, 456, equipment: :BURNER,
                             prereqs: Set[step_b1], immediate_prereq: step_b1)
    step_b3 = StepObject.new("Step B3", 5, :ALL, 123)

    builder = ScheduleBuilder.new([step_b3, step_b2, step_a3, step_a2],
                                  resources)
    builder.add_step(step_a3).should be_true
    builder.advance_current_time.should be_true
    builder.add_step(step_a2).should be_true
    builder.advance_current_time.should be_true
    builder.advance_current_time.should be_true
    builder.add_step(step_b3).should be_true
    builder.advance_current_time.should be_true
    builder.add_step(step_b2).should be_true
    builder.advance_current_time.should be_true
    builder.schedule_complete?.should be_true
    builder.advance_current_time.should be_true
    builder.schedule_complete?.should be_true
 end
end

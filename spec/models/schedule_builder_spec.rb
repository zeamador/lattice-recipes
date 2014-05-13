require 'spec_helper'

describe ScheduleBuilder do
  it "should be complete after adding only step and advancing the time" do
    resources = Resources.new(KitchenObject.new, 1)
    step = StepObject.new("Cut apples", 10, 2, 170)
    builder = ScheduleBuilder.new([step], resources)
    builder.add_step(step).should be_true
    builder.advance_current_time.should be_true
    builder.advance_current_time.should be_false
    builder.should be_schedule_complete
  end

  it "should fail to add a step when there is not enough focus for it" do
    resources = Resources.new(KitchenObject.new, 1)
    step_a = StepObject.new("Cut apples", 10, 2, 170)
    step_b = StepObject.new("Cut bananas", 6, 2, 170)
    builder = ScheduleBuilder.new([step_a, step_b], resources)
    builder.add_step(step_a).should be_true
    builder.add_step(step_b).should be_false
  end

  it "should fail to add a step when there are not enough resouces for it" do
    resources = Resources.new(KitchenObject.new, 1)
    step_a = StepObject.new("Bake apples", 10, 0, 170, equipment: [:OVEN])
    step_b = StepObject.new("Bake bananas", 20, 0, 170, equipment: [:OVEN])
    builder = ScheduleBuilder.new([step_a, step_b], resources)
    builder.add_step(step_a).should be_true
    builder.add_step(step_b).should be_false
  end
end

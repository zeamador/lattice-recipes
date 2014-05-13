require 'spec_helper'

describe ScheduleBuilder do
  it "should be complete after adding only step and advancing the time" do
    resources = Resources.new(KitchenObject.new, 1)
    step = StepObject.new("Cut apples", 10, 0, 1)
    builder = ScheduleBuilder.new([step], resources)
    builder.add_step(step).should be_true
    builder.advance_current_time.should be_true
    builder.advance_current_time.should be_false
    builder.should be_schedule_complete
  end
end

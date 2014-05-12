require 'spec_helper'

describe StepObject do
  it "should initialize omitted arguments to nil and empty set as appropriate" do
    step = StepObject.new("Let stand", 30, 0, 1234)
    expect(step.equipment).to eq(Set[])
    expect(step.prereqs).to eq(Set[])
    expect(step.immediate_prereq).to eq(nil)
    expect(step.preheat_prereq).to eq(nil)
  end

  it "should allow for initialization of subset of keyword arguments" do
    step_a = StepObject.new("Let meat stand", 30, 0, 1234)
    step_b = StepObject.new("Dip meat in sauce", 2, 2, 1234, 
                            immediate_prereq:step_a)
    expect(step_b.equipment).to eq(Set[])
    expect(step_b.prereqs).to eq(Set[])
    expect(step_b.immediate_prereq).to equal(step_a)
    expect(step_b.preheat_prereq).to eq(nil)
  end
end

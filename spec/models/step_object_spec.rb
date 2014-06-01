require 'spec_helper'

describe StepObject do
  it "should initialize omitted arguments to nil and empty set as appropriate" do
    step = StepObject.new("Let stand", 30, :NONE, 1234)
    expect(step.equipment).to eq(nil)
    expect(step.prereqs).to eq(Set[])
    expect(step.immediate_prereq).to eq(nil)
    expect(step.preheat_prereq).to eq(nil)
  end

  it "should allow for initialization of subset of keyword arguments" do
    step_a = StepObject.new("Let meat stand", 30, :NONE, 1234)
    step_b = StepObject.new("Dip meat in sauce", 2, :ALL, 1234,
                            immediate_prereq: step_a, prereqs: Set[step_a])
    expect(step_b.equipment).to eq(nil)
    expect(step_b.prereqs).to eq(Set[step_a])
    expect(step_b.immediate_prereq).to equal(step_a)
    expect(step_b.preheat_prereq).to eq(nil)
  end

  it "should disallow non-positive time values" do
    expect { StepObject.new("Time travel bake", -4, :ALL, 71) }.to raise_error(
        "Time was not given in positive minutes")
    expect { StepObject.new("Instant bake", 0, :ALL, 71) }.to raise_error(
        "Time was not given in positive minutes")
  end

  it "should disallow non-FocusType focus values" do
    expect { StepObject.new("Cook", 30, :BLAH, 71) }.to raise_error(
        "Focus must be a FocusTypes constant")
  end

  it "should allow FocusType focus values" do
    step_a = StepObject.new("Cook", 30, :NONE, 71)
    expect(step_a.focus).to eq(:NONE)
    step_b = StepObject.new("Cook", 30, :SOME, 71)
    expect(step_b.focus).to eq(:SOME)
    step_c = StepObject.new("Cook", 30, :ALL, 71)
    expect(step_c.focus).to eq(:ALL)
  end

  it "should disallow preheat/immediate prereqs not in the prereqs set" do
    step = StepObject.new("Let meat stand", 30, :NONE, 1234)
    expect { StepObject.new("Dip meat in sauce", 2, :ALL, 1234,
                            immediate_prereq: step) }.to raise_error(
        "Not all special prereqs were in the given set of prereqs")

    other_step = StepObject.new("Let meat stand", 30, :NONE, 1234)
    expect { StepObject.new("Dip meat in sauce", 2, :ALL, 1234,
                            preheat_prereq: step,
                            prereqs: Set[other_step]) }.to raise_error(
        "Not all special prereqs were in the given set of prereqs")
  end

  it "should only except nil or EquipmentType constants for equipment" do
    expect { StepObject.new("Bad Equipment", 20, :NONE, 1234,
                            equipment: "dogs") }.to raise_error(
        "Equipment must either be nil or an EquipmentTypes constant")
  end

  it "should only print the step description" do
    step = StepObject.new("Instructions for something", 20, :NONE, 1234)
    expect(step.to_s).to eq("Instructions for something")
    expect(step.inspect).to eq("Instructions for something")
  end
end

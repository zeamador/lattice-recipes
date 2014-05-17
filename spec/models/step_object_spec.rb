require 'spec_helper'

describe StepObject do
  it "should initialize omitted arguments to nil and empty set as appropriate" do
    step = StepObject.new("Let stand", 30, 0, 1234)
    expect(step.equipment).to eq(nil)
    expect(step.prereqs).to eq(Set[])
    expect(step.immediate_prereq).to eq(nil)
    expect(step.preheat_prereq).to eq(nil)
  end

  it "should allow for initialization of subset of keyword arguments" do
    step_a = StepObject.new("Let meat stand", 30, 0, 1234)
    step_b = StepObject.new("Dip meat in sauce", 2, 2, 1234, 
                            immediate_prereq: step_a, prereqs: Set[step_a])
    expect(step_b.equipment).to eq(nil)
    expect(step_b.prereqs).to eq(Set[step_a])
    expect(step_b.immediate_prereq).to equal(step_a)
    expect(step_b.preheat_prereq).to eq(nil)
  end

  it "should disallow non-positive time values" do
    expect { StepObject.new("Time travel bake", -4, 2, 71) }.to raise_error(
        "Time was not given in positive minutes")
    expect { StepObject.new("Instant bake", 0, 2, 71) }.to raise_error(
        "Time was not given in positive minutes")
  end

  it "should disallow attentiveness values that aren't 0, 1, or 2" do
    expect { StepObject.new("Cook", 30, 3, 71) }.to raise_error(
        "Focus must be integer value 0 = NONE, 1 = SOME, or 2 = ALL")
    expect { StepObject.new("Cook", 30, -1, 71) }.to raise_error(
        "Focus must be integer value 0 = NONE, 1 = SOME, or 2 = ALL")
    expect { StepObject.new("Cook", 30, 0.5, 71) }.to raise_error(
        "Focus must be integer value 0 = NONE, 1 = SOME, or 2 = ALL")
    expect { StepObject.new("Cook", 30, "dog", 71) }.to raise_error(
        "Focus must be integer value 0 = NONE, 1 = SOME, or 2 = ALL")
  end

  it "should allow attentiveness values of 0, 1, and 2" do
    step_a = StepObject.new("Cook", 30, 0, 71)
    expect(step_a.focus).to eq(0)
    step_b = StepObject.new("Cook", 30, 1, 71)
    expect(step_b.focus).to eq(1)
    step_c = StepObject.new("Cook", 30, 2, 71)
    expect(step_c.focus).to eq(2)
  end

  it "should disallow preheat/immediate prereqs not in the prereqs set" do
    step = StepObject.new("Let meat stand", 30, 0, 1234)
    expect { StepObject.new("Dip meat in sauce", 2, 2, 1234, 
                            immediate_prereq: step) }.to raise_error(
        "Not all special prereqs were in the given set of prereqs")

    other_step = StepObject.new("Let meat stand", 30, 0, 1234)
    expect { StepObject.new("Dip meat in sauce", 2, 2, 1234, 
                            preheat_prereq: step, 
                            prereqs: Set[other_step]) }.to raise_error(
        "Not all special prereqs were in the given set of prereqs")
  end

  it "should only except nil or EquipmentType constants for equipment" do
    StepObject.new("No Error", 20, 0, 1234, equipment: nil)
    expect { StepObject.new("Error", 20, 0, 1234, 
                            equipment: "dogs").to raise_error(
        "Equipment must either be nil or an EquipmentType constant") }
  end
end

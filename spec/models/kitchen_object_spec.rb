require 'spec_helper'

describe KitchenObject do
  it "should be intialized with four burners" do
    kitchen = KitchenObject.new
    expect(kitchen[:BURNER]).to eq(4)
  end
  
  it "should be intialized with one oven" do
    kitchen = KitchenObject.new
    expect(kitchen[:OVEN]).to eq(1)
  end

  it "should be intialized with one microwave" do
    kitchen = KitchenObject.new
    expect(kitchen[:MICROWAVE]).to eq(1)
  end

  it "should be intialized with one sink" do
    kitchen = KitchenObject.new
    expect(kitchen[:SINK]).to eq(1)
  end

  it "should be intialized with one toaster" do
    kitchen = KitchenObject.new
    expect(kitchen[:TOASTER]).to eq(1)
  end

  it "should allow for equipment quantity updates" do
    kitchen = KitchenObject.new
    kitchen[:SINK] = 7
    expect(kitchen[:SINK]).to eq(7)
  end

  it "should raise an error when accessing non-equipment types" do
    kitchen = KitchenObject.new
    expect {kitchen[:DOG]}.to raise_error(
        "Attempted to access an invalid equipment type")
  end

  it "should raise an error when assigning to non-equipment types" do
    kitchen = KitchenObject.new
    expect {kitchen[:DOG] = 3 }.to raise_error(
        "Attempted to add invalid equipment type to kitchen")
  end

  it "should raise an error when assigning negative quantity" do
    kitchen = KitchenObject.new
    expect {kitchen[:BURNER] = -2 }.to raise_error(
        "Attempted to add negative quantity of equipment type to kitchen")
  end
end

class Kitchen < ActiveRecord::Base
  
  # Public: Initialize kitchen with default equipment settings.
  def initialize
    @equipment = { BURNER => 4, OVEN => 1, MICROWAVE => 1, 
                   SINK => 1, TOASTER => 1 }
  end

  # Public: View quantity of the given equipment type in this kitchen.
  #
  # equipment_type - An equipment_types constant.
  #
  # Example: my_kitchen[SINK]
  #
  # Returns quantity of the given equipment type in this kitchen, 
  # or returns nil if input is not an equipment_type constant
  def [](equipment_type)
    @equipment[equipment_type]
  end

  # Public: Modify quantity of the given equipment type in this kitchen.
  #
  # equipment_type - An equipment_types constant.
  # quantity - The new integer equipment quantity.
  #
  # Example: my_kitchen[SINK] = 7
  #
  # Returns the updated quantity of the given equipment type in this kitchen, 
  # or raises an exception if equipment_type parameter is not a valid
  # equipment_type constant
  def []=(equipment_type, quantity)
    if(@equipment.has_key?(equipment_type))
      @equipment[equipment_type] = quantity
    else
      raise "Attempted to add invalid equipment type to kitchen"
    end
  end

end

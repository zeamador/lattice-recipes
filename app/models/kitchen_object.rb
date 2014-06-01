# Mutable container for the quantities of various equipment items in a user's
# physical kitchen.
class KitchenObject

  # Public: Initialize kitchen with default equipment settings.
  def initialize
    @equipment = { :BURNER => 4, :OVEN => 1, :MICROWAVE => 1,
                   :SINK => 1, :TOASTER => 1 }
  end

  def initialize_copy(other)
    super
    @equipment = @equipment.clone
  end

  # Public: View quantity of the given equipment type in this kitchen.
  #
  # equipment_type - An equipment_types constant.
  #
  # Example: my_kitchen[:SINK]
  #
  # Returns quantity of the given equipment type in this kitchen.
  # Raises an exception if input is not an equipment_type constant.
  def [](equipment_type)
    if(!EquipmentTypes.constants.include?(equipment_type))
      raise "Attempted to access an invalid equipment type"
    end

    res = @equipment[equipment_type]
    res ? res : 0
  end

  # Public: Modify quantity of the given equipment type in this kitchen.
  #
  # equipment_type - An equipment_types constant.
  # quantity - The new integer equipment quantity.
  #
  # Example: my_kitchen[:SINK] = 7
  #
  # Returns the updated quantity of the given equipment type in this kitchen.
  # Raises an exception if equipment_type parameter is not a valid
  # equipment_type constant or if quantity is negative.
  def []=(equipment_type, quantity)
    if(!EquipmentTypes.constants.include?(equipment_type))
      raise "Attempted to add invalid equipment type to kitchen"
    elsif(quantity < 0)
      raise "Attempted to add negative quantity of equipment type to kitchen"
    end

    @equipment[equipment_type] = quantity
  end
end

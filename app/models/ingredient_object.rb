# Immutable recipe ingredient.
class IngredientObject

  attr_reader :description, :quantity, :units

  # Public: Initalize an ingredient.
  # 
  # description - String name of ingredient.
  # quantity - Integer quantity of ingredient.
  # units - Lowercase plural String name of units (cups, not cup), 
  #         use "whole" if units are inappropriate.
  def initialize(description, quantity, units)
    @description = description
    @quantity = quantity
    @units = units
  end
end

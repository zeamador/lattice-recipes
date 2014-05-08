class Ingredient < ActiveRecord::Base
  attr_reader :description, :quantity, :units

  # Public: Initalize an ingredient.
  # 
  # description - String name of ingredient.
  # quantity - Integer quantity of ingredient.
  # units - Lowercase string name of units, 
  #         use "whole" if units are inappropriate.
  def initialize(description, quantity, units)
    @description = description
    @quantity = quantity
    @units = units
  end
end

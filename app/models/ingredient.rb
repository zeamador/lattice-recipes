# Immutable recipe ingredient.
class Ingredient < ActiveRecord::Base
  belongs_to :recipe

  attr_reader :description, :quantity, :units

  # Public: Initalize an ingredient.
  # 
  # description - String name of ingredient.
  # quantity - Integer quantity of ingredient.
  # units - Lowercase String name of units, 
  #         use "whole" if units are inappropriate.
  def initialize(description, quantity, units)
    @description = description
    @quantity = quantity
    @units = units
  end
end

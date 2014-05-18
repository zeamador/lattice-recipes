class IngredientFactory < ObjectFactory
  def initialize
    @db_class = Ingredient
  end

  private
  # See ObjectFactory
  def construct_new_object(db_ingredient)
    IngredientObject.new(db_ingredient.description, db_ingredient.quantity, 
                         db_ingredient.units)
  end
end

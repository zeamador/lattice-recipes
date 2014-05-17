class IngredientFactory
  def get_ingredient_from_db_id(db_ingredient_id)
    get_ingredient_from_db_object(Ingredient.find(db_ingredient_id))
  end  

  def get_ingredient_from_db_object(db_ingredient)
    unless @ingredients.has_key?(db_ingredient.id)
      @ingredients[db_ingredient.id] = construct_new_ingredient(db_ingredient)
    end

    @ingredients[db_ingredient.id]
  end

  private:
  def construct_new_ingredient(db_ingredient)
    IngredientObject.new(db_ingredient.description, db_ingredient.quantity, 
                         db_ingredient.units)
  end
end

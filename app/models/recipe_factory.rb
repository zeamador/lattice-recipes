class RecipeFactory
  def get_recipe_from_db_id(db_recipe_id)
    get_recipe_from_db_object(Recipe.find(db_recipe_id))
  end  

  def get_recipe_from_db_object(db_recipe)
    unless @recipes.has_key?(db_recipe.id)
      @recipes[db_recipe.id] = construct_new_recipe(db_recipe)
    end

    @recipes[db_recipe.id]
  end

  private:
  def construct_new_recipe(db_recipe)
    step_maker = StepFactory.new
    ingred_maker = IngredientFactory.new

    ingredients = Set[]
    db_recipe.ingredients.each do |db_ingredient|
      ingredients << ingred_maker.get_ingredient_from_db_object(db_ingredient)
    end

    final_steps = Set[]
    db_recipe.steps.each do |db_step|
      if db_step.final_step
        final_steps << step_maker.get_step_from_db_object(db_step)
      end
    end

    RecipeObject.new(db_recipe.id, db_recipe.title, ingredients, final_steps)
  end
end

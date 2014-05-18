class RecipeFactory < ObjectFactory
  def initialize
    @db_class = Recipe
  end

  private
  # See ObjectFactory
  def construct_new_object(db_recipe)
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

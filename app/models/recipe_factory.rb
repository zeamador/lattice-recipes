class RecipeFactory < ObjectFactory
  def initialize
    super
    @db_class = Recipe
  end

  private
  # See ObjectFactory
  def construct_new_object(db_recipe)
    step_maker = StepFactory.new

    final_steps = Set[]
    db_recipe.steps.each do |db_step|
      if db_step.final_step
        final_steps << step_maker.get_object_from_db_object(db_step)
      end
    end

    RecipeObject.new(db_recipe.id, db_recipe.title,
                     db_recipe.ingredients, final_steps)
  end
end

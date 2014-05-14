module RecipesHelper

  def recent_recipes
    @recent_recipes = Recipe.order("created_at DESC").limit("3")
  end
end

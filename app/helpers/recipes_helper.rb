module RecipesHelper

  def recent_recipes
    @recent_recipes = Recipe.order(created_at: :desc).limit("3")
  end

end

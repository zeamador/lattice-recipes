module RecipesHelper

  def recent_recipes
    @recent_recipes = Recipe.where("temp = ?", false).where("secret = ?", false).order(created_at: :desc).limit("3")
  end

end

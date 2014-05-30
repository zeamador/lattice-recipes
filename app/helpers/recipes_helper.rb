module RecipesHelper

  # Recent_recipes to use on the latest recipes section in side-bar
  def recent_recipes
  	if signed_in? # If signed in, also display current user's secret recipe
    	@recent_recipes = Recipe.where("temp = ?", false).where("secret = ? OR user_id = ?", false, current_user.id).order(created_at: :desc).limit("3")
  	else
  		@recent_recipes = Recipe.where("temp = ?", false).where("secret = ?", false).order(created_at: :desc).limit("3")
  	end
  end

end

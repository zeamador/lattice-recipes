module RecipesHelper

  def recent_recipes
  	if signed_in?
    	@recent_recipes = Recipe.where("temp = ?", false).where("secret = ? OR user_id = ?", false, current_user.id).order(created_at: :desc).limit("3")
  	else
  		@recent_recipes = Recipe.where("temp = ?", false).where("secret = ?", false).order(created_at: :desc).limit("3")
  	end
  end

end

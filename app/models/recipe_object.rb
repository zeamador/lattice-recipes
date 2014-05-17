# Immutable single recipe
class RecipeObject
  attr_reader :recipe_id, :title, :ingredients, :final_steps, :secret, :tags
  alias_method :secret?, :secret

  # Public: Initialize a Recipe with required features.
  #
  # recipe_id - Integer uniquely identifying this recipe.
  # title - String description of recipe.
  # ingredients - Set of Ingredient objects.
  # final_steps - Set of Step objects in the recipe that are not prereqs 
  #               for any other step in the recipe.
  #
  # Raises error if final_steps is empty.
  def initialize(recipe_id, title, ingredients, final_steps)
    @recipe_id = recipe_id
    @title = title
    @ingredients = ingredients

    # set of final steps should not be empty
    if(final_steps && !final_steps.empty?)
      @final_steps = final_steps
    else
      raise "Set of final steps must contain at least one step"
    end
  end
end

# Immutable single recipe
class Recipe < ActiveRecord::Base
  has_many :step 
  has_many :ingredient
  belongs_to :user

  attr_reader :recipe_id, :title, :ingredients, :final_steps, :secret, :tags
  alias_method :secret?, :secret

  # Public: Initialize a Recipe with required features.
  #
  # recipe_id - Integer uniquely identifying this recipe.
  # title - String description of recipe.
  # ingredients - Set of Ingredient objects.
  # final_steps - Set of Step objects in the recipe that are not prereqs 
  #               for any other step in the recipe.
  # secret - Boolean indicating privacy setting, true = secret, false = public.
  # tags - Set of case-insensitive Strings.
  def initialize(recipe_id, title, ingredients, final_steps, secret, tags)
    @recipe_id = recipe_id
    @title = title
    @ingredients = ingredients
    @final_steps = final_steps
    @secret = secret
    @tags = tags
  end
end

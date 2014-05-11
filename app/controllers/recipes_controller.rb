class RecipesController < ApplicationController

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      flash[:success] = "Thank you for your submission!"
      redirect_to @recipe
    else
      render 'new'
    end
  end

  private

    def recipe_params
      params.require(:recipe).permit(:title, :ingredients, :final_steps, :secret,
                                     :tags)
    end
end

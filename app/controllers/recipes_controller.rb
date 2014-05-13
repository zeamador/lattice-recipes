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
      redirect_to 'new'
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to root_url
  end

  private

    def recipe_params
      params.require(:recipe).permit(:title, :ingredients, :final_steps, :secret,
                                     :tags)
    end
end

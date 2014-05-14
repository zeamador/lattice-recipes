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
      flash[:recipe_success] = "Great! Now we need info about the ingredients and steps."
      redirect_to recipe_path(@recipe, :add => 1)
    else
      render 'new'
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to root_url
  end

  def index
    if params[:search]
      @recipes = Recipe.search(params[:search]).order("created_at DESC")
    else
      @recipes = Recipe.order("created_at DESC")
    end
  end

  private

    def recipe_params
      params.require(:recipe).permit(:title, :secret, :tags)
    end

end

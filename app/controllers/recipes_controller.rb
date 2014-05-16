class RecipesController < ApplicationController

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    2.times { @recipe.ingredients.build }
    2.times do 
      step = @recipe.steps.build
      2.times { step.step_mappers.build }
    end
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      flash[:recipe_success] = "Great! Now we need info about the ingredients and steps."
      redirect_to recipe_path(@recipe)
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
      @recipes = Recipe.search(params[:search]).order(created_at: :desc)
    else
      @recipes = Recipe.order(created_at: :desc)
    end
  end

  private

    def recipe_params
      params.require(:recipe).permit(:title, :secret, :tags, 
                                     ingredients_attributes: [:id, :quantity,
                                                              :unit,
                                                              :description],
                                     steps_attributes: [:id, :step_number,
                                                        :description, :time,
                                                        :attentiveness,
                                                        :final_step])
    end

end

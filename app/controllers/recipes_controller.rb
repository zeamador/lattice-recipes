class RecipesController < ApplicationController

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    10.times { @recipe.ingredients.build }
    10.times do 
      step = @recipe.steps.build
      3.times { step.step_mappers.build }
    end
  end

  def create
#    @user = User.find(params[:user_id])
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      @user = current_user
	  @recipe.user = @user
      @recipe.save
      flash[:recipe_success] = "Great! Your recipe is created!"
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
                                                        :final_step, :equipment,
                                     step_mappers_attributes: [:id,
                                                               :immediate_prereq,
                                                               :prereq_id,
                                                               :prereq_step_number]])
    end

end

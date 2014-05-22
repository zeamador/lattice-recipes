class RecipesController < ApplicationController

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    step = @recipe.steps.build
    step.step_mappers.build
  end

  def create
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

  def addToMeal
    @recipe = Recipe.find(params[:id])

    # Make a copy of recipe
    @tmp_recipe = @recipe.dup
    @tmp_recipe.temp = true
    @tmp_recipe.user = current_user
    @steps_arry = Array.new
    @steps_hash = Hash.new
    @steps = @recipe.steps
    for @step in @steps
      @tmp_step = @step.dup
      @tmp_step.save
      @steps_arry.push(@tmp_step.id)
      @steps_hash[@tmp_step.step_number] = @tmp_step.id
      for @sm in @step.step_mappers
        @tmp_sm = @sm.dup
        @tmp_sm.step = @tmp_step
        @tmp_sm.save
      end
    end
    @tmp_recipe.step_ids = @steps_arry
    @tmp_recipe.save
    for @step in @tmp_recipe.steps
      for @sm in @step.step_mappers
        @sm.prereq_id = @steps_hash[@sm.prereq_step_number]
        @sm.save
      end
    end

    @tmp_recipe.update_attribute(:meal_id, params[:meal_id])
    redirect_to meal_path(current_user.meal)
  end

  def update
    
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to root_url
  end

  def index
    if params[:search]
      @recipes = Recipe.search(params[:search]).where("temp = ?", false).order(created_at: :desc)
    else
      @recipes = Recipe.where("temp = ?", false).order(created_at: :desc)
    end
  end

  private

    def recipe_params
      params.require(:recipe).permit(:title, :secret, :tags, :meal_id, 
                                     :ingredients,
                                     steps_attributes: [:id, :step_number,
                                                        :description, :time,
                                                        :attentiveness,
                                                        :final_step, :equipment,
                                                        :_destroy,
                                     step_mappers_attributes: [:id,
                                                               :immediate_prereq,
                                                               :prereq_id,
                                                               :prereq_step_number,
                                                               :_destroy]])
    end

end

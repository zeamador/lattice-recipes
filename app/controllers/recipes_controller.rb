class RecipesController < ApplicationController

  def show
    @recipe = Recipe.find(params[:id])
    @total_time = 0
    for @step in @recipe.steps
      @total_time += @step.time
    end
  end

  def new
    @recipe = Recipe.new
    step = @recipe.steps.build
    step.step_mappers.build
  end

  def create
    @recipe = Recipe.new(recipe_params)
    valid = prereq_validation(recipe_params)
    if valid
      if @recipe.save
        @user = current_user
        @recipe.user = @user
        @recipe.save
        flash[:recipe_success] = "Great! Your recipe is created!"
        redirect_to recipe_path(@recipe)
      else
        render 'new'
      end
    else
      flash[:recipe_error] = "There was a problem with your prerequisite step entry. Please press back to restore your input."
      render 'new'
    end
  end

  # For use with the user's meal, creates a temporary copy
  # of the recipe for customization by the user.
  def add_to_meal
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

  def remove
    @recipe = Recipe.find(params[:recipe_id])
    @recipe.destroy
    redirect_to(:back)
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])

    if @recipe.update(recipe_params)
      flash[:recipe_success] = "Your changes are saved."
      redirect_to @recipe
    else
      render 'edit'
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to root_url
  end

  def index
    if params[:search]
      if signed_in?
        @recipes = Recipe.search(params[:search]).where("temp = ?", false).where("secret = ? OR user_id = ?", false, current_user.id).order(created_at: :desc)
      else
        @recipes = Recipe.search(params[:search]).where("temp = ?", false).where("secret = ?", false).order(created_at: :desc)
      end
    else
      if signed_in?
        @recipes = Recipe.where("temp = ?", false).where("secret = ? OR user_id = ?", false, current_user.id).order(created_at: :desc)
      else
        @recipes = Recipe.where("temp = ?", false).where("secret = ?", false).order(created_at: :desc)
      end
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :secret, :tags, :meal_id, :serving,
                                   :ingredients, :avatar, :notes,
                                   steps_attributes: [:id, :step_number,
                                                      :description, :time,
                                                      :attentiveness,
                                                      :final_step, :equipment,
                                                      :_destroy,
                                   step_mappers_attributes: [:id,
                                                             :preheat_prereq,
                                                             :immediate_prereq,
                                                             :prereq_id,
                                                             :prereq_step_number,
                                                             :_destroy]])
  end

  def prereq_validation(given_params)
    given_params[:steps_attributes].each do |attributes|
      attributes.each do |step|
        if step.include?("step_mappers_attributes")
          nums = []
          immeds = []
          preheats = []
          step[:step_mappers_attributes].each do |mapper|
            if mapper[1][:_destroy] == "false"
              nums.push(mapper[1][:prereq_step_number])
              immeds.push(mapper[1][:immediate_prereq])
              preheats.push(mapper[1][:preheat_prereq])
            end
            unless nums == nums.uniq
              return false
            end
            num_immeds = 0
            immeds.each do |immed|
              if immed == "1"
                num_immeds = num_immeds + 1
              end
              if num_immeds > 1
                return false
              end
            end
            num_preheats = 0
            preheats.each do |preheat|
              if preheat == "1"
                num_preheats = num_preheats + 1
              end
              if num_preheats > 1
                return false
              end
            end
          end
        end
      end
    end
  end

end

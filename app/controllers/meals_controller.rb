class MealsController < ApplicationController

  def show
    @meal = Meal.find(params[:id])
    @need_equipments_by_id = Hash.new
    @meal.recipes.each do |recipe|
      @equipment_warning = ""
      # Get all equipments in EquipmentTypes
      @all_equipments = Set.new
      EquipmentTypes.constants.each do |constant|
        @all_equipments << "#{constant}".downcase()
      end

      # Get all missing equipment for current user
      @missing_equipments = Set.new
      @all_equipments.each do |equipment|
        if current_user.kitchen.attributes[equipment] < 1
          @missing_equipments << equipment
        end
      end

      # Check through the recipe whether there's a step that
      #  needs missing equipment
      @need_equipments = Set.new
      recipe.steps.each do |step|
        if @missing_equipments.include? step.equipment
          @need_equipments << step.equipment
        end
      end

      @need_equipments_by_id[recipe.id] = @need_equipments
    end
  end

  # Update the number of cooks for this meal
  def update
    @meal = Meal.find(params[:id])
    @meal.update_attributes(meal_params)
    redirect_to :controller => 'meal_schedules', :action => 'show'
  end

  private

  def meal_params
    params.require(:meal).permit(:cooks)
  end

end

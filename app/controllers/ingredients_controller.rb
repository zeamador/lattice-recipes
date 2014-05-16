class IngredientsController < ApplicationController

  private

    def ingredient_params
      params.require(:ingredient).permit(:quantity, :unit, :description)
    end
end

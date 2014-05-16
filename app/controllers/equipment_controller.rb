class EquipmentController < ApplicationController

  private

    def equipment_params
      params.require(:equipment).permit(:burner, :oven, :microwave, :sink, 
                                        :toaster)
    end
end

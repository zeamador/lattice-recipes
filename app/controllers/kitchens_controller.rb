class KitchensController < ApplicationController

  def update
    @user = User.find(params[:id])
	@kitchen = @user.kitchen
	if @kitchen.update_attributes(kitchen_params)
	  flash[:success] = "Kitchen updated!"
	end
	redirect_to @user
  end

  private

    def kitchen_params
      params.require(:kitchen).permit(:burner, :oven, :microwave,
                                   :sink, :toaster)
    end
end

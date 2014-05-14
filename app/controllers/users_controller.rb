class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @kitchen = @user.kitchen
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
    @kitchen = Kitchen.new()
    @kitchen.save
    @user.kitchen = @kitchen
    @user.save
    sign_in @user
    flash[:login_success] = "Welcome to Lattice Recipes, " + @user.name + "!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end

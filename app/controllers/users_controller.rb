class UsersController < ApplicationController
  before_action :signed_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:show, :edit, :update]

  # Recipes to display on myrecipes page
  def myrecipes
    # Whether with query:
    # if so, search by title or tag
    # if not, display all recipes
    # Sort by created time in desc order
    if params[:search]
      lowered = params[:search].downcase # => case insensitive
      @my_recipes = Recipe.where("user_id = ? AND temp = ? AND (lower(title) like ? OR tags like ?)", current_user.id, false, "%#{lowered}%", "%#{lowered}%")
    else
      @my_recipes = Recipe.where("user_id = ? AND temp = ?", current_user.id, false).order(created_at: :desc)
    end
  end

  def show
    @user = User.find(params[:id])
    @kitchen = @user.kitchen
  end

  def new
    if current_user.nil?
      @user = User.new
    else
      redirect_to root_url
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Create a default kitchen for a new user
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

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Password changed!"
      redirect_to @user
    else
      flash[:error] = "Password wasn't changed! Make sure the password is 6
 to 20 characters. Letters, numbers, dashes, and periods are the allowed characters."
      redirect_to @user
    end
  end

  def destroy
    @user = User.find(params[:id])
    @recipes = @user.recipes
    @recipes.each do |recipe|
      if recipe.secret
        recipe.destroy
      else
        recipe.user = nil
        recipe.save
      end
    end
    @user.destroy
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Check whehter has signed in user
  # Otherwise can't do show, edit and update
  def signed_in_user
    redirect_to root_url, notice: "Please sign in." unless signed_in?
  end

  # Check whether the current_user is the user it required for
  # Otherwise can't do show, edit and update
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end

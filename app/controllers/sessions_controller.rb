class SessionsController < ApplicationController

  def new
  end

  def create
	user = User.find_by(email: params[:session][:email].downcase)
	if user && user.authenticate(params[:session][:password])
	  flash[:success] = "Welcome back, " + user.name + "!"
	  sign_in user
	  redirect_to root_url
	else
	  flash[:error] = 'Invalid email or password.'
	  redirect_to root_url
	end
  end

  def destroy
    sign_out
	redirect_to root_url
  end

end
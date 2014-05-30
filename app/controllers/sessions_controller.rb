class SessionsController < ApplicationController

  def new
  end

  # Authenticates password, creates session and signs the user in
  # on success; otherwise, flash login_error
  def create
	user = User.find_by(email: params[:session][:email].downcase)
	if user && user.authenticate(params[:session][:password])
	  sign_in user
	  redirect_to(:back)
	else
	  flash[:login_error] = 'Invalid email or password.'
	  redirect_to root_url
	end
  end

  # On destroy, sign out the current_user
  def destroy
    sign_out
	redirect_to root_url
  end

end

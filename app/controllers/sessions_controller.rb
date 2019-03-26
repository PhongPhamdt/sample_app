class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate(params[:session][:password])
      logged user
    else
      flash.now[:danger] = t ".flash_danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def logged user
    log_in user
    check = params[:session][:remember_me]
    check == Settings.check_box.to_s ? remember(user) : forget(user)
    redirect_to user
  end
end

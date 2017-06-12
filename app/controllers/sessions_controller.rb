class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      flash[:success] = t ".welcome_back"
      redirect_to user
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = t ".see_you_again"
    redirect_to root_url
  end
end

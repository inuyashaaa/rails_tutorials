class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      log_in user
      "1" == params[:session][:remember_me] ? remember(user) : forget(user)
      flash[:success] = t ".welcome_back"
      redirect_back_or user
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

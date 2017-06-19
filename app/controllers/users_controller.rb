class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin, only: :destroy

  def index
    @users = User.select(:id, :name, :email, :is_admin).activated
      .order(:name).page(params[:page]).per_page Settings.user.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def show
    return if @user.activated
    flash[:danger] =  t ".cant_show"
    redirect_to root_url
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".flash"
      redirect_to @user
    else
      flash.now[:danger] = t ".error"
      render :edit
    end
  end

  def destroy
    @user.destroy ? (flash[:success] = t ".deleted") : (flash.now[:error] = t ".error")
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    @user = User.find_by id: params[:id]

    unless @user.is_user? current_user
      flash[:danger] = t ".error"
      redirect_to root_url
    end
  end

  def load_user
    @user = User.find_by id: params[:id]
    @microposts = @user.microposts.paginate page: params[:page]

    if @user.nil?
      render file: "public/404.html", status: :not_found, layout: false
    end
  end

  def verify_admin
    redirect_to root_url unless current_user.is_admin?
  end
end

class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :destroy, :update]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t ".flash_success"
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @follow = current_user.active_relationships.build
    @unfollow = current_user.active_relationships.find_by followed_id: @user.id
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t ".flash_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user
      @user.destroy
      flash[:success] = t ".flash_success"
      redirect_to users_url
    else
      flash[:danger] = t ".flash_danger"
      redirect_to root_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation, :gender, :date_of_birth)
  end

  def correct_user
    redirect_to(root_url) unless current_user.current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    @microposts =
      @user.microposts.paginate page: params[:page], per_page: Settings.per_page

    return if @user
    flash[:danger] = t ".flash_danger"
    redirect_to root_path
  end
end

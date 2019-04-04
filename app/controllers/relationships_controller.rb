class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @title = t ".#{params[:type]}"
    @user = User.find_by id: params[:id]
    redirect_to root_path unless @user
    if params[:type] == "following"
      @users = @user.following.paginate page: params[:page]
      render "users/show_follow"

    elsif params[:type] == "followers"
      @users = @user.followers.paginate page: params[:page]
      render "users/show_follow"
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end

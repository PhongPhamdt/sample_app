class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @title = t ".#{params[:type]}"
    check params[:id]
    if params[:type] == "following"
      ren_following params[:page]
    elsif params[:type] == "followers"
      ren_followers params[:page]
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

  def check uid
    @user = User.find_by id: uid
    redirect_to root_path unless @user
  end

  def ren_following page_num
    @users = @user.following.paginate page: page_num
    render "users/show_follow"
  end

  def ren_followers page_num
    @users = @user.followers.paginate page: page_num
    render "users/show_follow"
  end
end

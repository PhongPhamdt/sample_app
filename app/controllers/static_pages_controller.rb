class StaticPagesController < ApplicationController
  def home
    return if logged_in?.nil?
    @micropost = current_user.microposts.build
    @feed_items =
      current_user.microposts.sort_by_created.paginate(page: params[:page])
  end

  def help; end

  def contact; end

  def about; end
end

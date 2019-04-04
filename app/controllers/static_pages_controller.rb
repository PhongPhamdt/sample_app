class StaticPagesController < ApplicationController
  def home
    return if logged_in?.nil?
    @micropost = current_user.microposts.build
    @feed_items = Micropost.feed(current_user)
                           .sort_by_created
                           .paginate(page: params[:page],
                            per_page: Settings.per_page)
  end

  def help; end

  def contact; end

  def about; end
end

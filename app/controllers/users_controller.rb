class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
    @posts_count = @posts.count
  end
end

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post

  def create
    @like = @post.likes.build(user: current_user)

    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: t('likes.created') }
      end
    else
      redirect_to @post, alert: t(likes.not_found)
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)

    if @like&.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: t('likes.deleted') }
      end
    else
      redirect_to @post, alert: t(likes.not_found)
    end
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end
end

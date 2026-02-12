class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post

  def create
    @like = @post.likes.build(user: current_user)

    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: 'いいねしました' }
      end
    else
      redirect_to @post, alert: 'いいねに失敗しました'
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)

    if @like&.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: 'いいねを取り消しました' }
      end
    else
      redirect_to @post, alert: 'いいね取り消しに失敗しました'
    end
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end
end

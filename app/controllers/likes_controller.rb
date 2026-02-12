class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post

  def create
    # 既存のいいねがある場合はそれを削除、ない場合は新規作成
    @like = @post.likes.find_by(user: current_user)
    
    if @like
      # 既存のいいねを削除
      @like.destroy
    else
      # 新規いいねを作成
      @like = @post.likes.build(user: current_user)
      @like.save
    end

    @post.reload

    respond_to do |format|
      format.json do
        render json: {
          success: true,
          liked: @post.liked_by?(current_user),
          likes_count: @post.likes_count
        }
      end
      format.html { head :no_content }
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    @like&.destroy

    @post.reload

    respond_to do |format|
      format.json do
        render json: {
          success: true,
          liked: @post.liked_by?(current_user),
          likes_count: @post.likes_count
        }
      end
      format.html { head :no_content }
    end
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end
end

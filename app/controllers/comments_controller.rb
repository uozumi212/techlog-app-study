class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: t('comments.created')
    else
      redirect_to @post, alert: @comment.errors.full_messages.join(', ')
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    redirect_to root_path, alert: t('comments.not_authorized') and return unless @comment.user == current_user

    if @comment.destroy
      redirect_to @post, notice: t('comments.deleted')
    else
      redirect_to @post, alert: t('comments.not_found')
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.expect(comment: [:content])
  end
end

class PostsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  
  def index
    @posts = Post.limit(10).order(created_at: :desc)
  end

  def show
    # @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:notice] = '投稿しました'
      redirect_to posts_path
    else
      flash[:alert] = '投稿に失敗しました'
      render :new
    end
  end
  
  def edit
  
  end
  
  def update
  	if @post.update(post_params)
   		flash[:notice] = '投稿を更新しました'
      redirect_to @post
    else
    	flash[:alert] = '更新に失敗しました'
      render :edit
    end
  end

  def destroy
    post = Post.find_by(id: params[:id])

    if post.user == current_user
      post.destroy
      flash[:notice] = '投稿が削除されました'
    end

    redirect_to posts_path
  end

  private

  def post_params
    params.expect(post: [:title, :content])
  end
  
  def find_post
  	@post = Post.find_by(id: params[:id])
    redirect_to posts_path, alert: "投稿が見つかりません" unless @post
  end
  
  def authorize_user!
  	redirect_to posts_path, alert: '権限がありません' unless @post.user == current_user
  end
end

class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
  	# 検索パラメータを取得
    @keyword = params[:keyword]
    @user_id = params[:user_id]
    @sort = params[:sort]
    
    # ユーザー一覧を取得（フィルタ用）
    @users = User.all
  
    @posts = Post.search(keyword: @keyword, user_id: @user_id, sort: @sort).limit(10)
  end

  def show
    # @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:notice] = t('posts.created')
      redirect_to posts_path
    else
      flash[:alert] = t('posts.create_failed')
      render :new
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = t('posts.updated')
      redirect_to @post
    else
      flash[:alert] = t('posts.update_failed')
      render :edit
    end
  end

  def destroy
    post = Post.find_by(id: params[:id])

    if post.user == current_user
      post.destroy
      flash[:notice] = t('posts.deleted')
    end

    redirect_to posts_path
  end

  private

  def post_params
    params.expect(post: [:title, :content])
  end

  def find_post
    @post = Post.find_by(id: params[:id])
    redirect_to posts_path, alert: t('posts.not_found') unless @post
  end

  def authorize_user!
    redirect_to posts_path, alert: t('posts.not_authorized') unless @post.user == current_user
  end
end

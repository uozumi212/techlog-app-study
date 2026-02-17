class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    # 検索パラメータを取得
    @keyword = params[:keyword]
    @user_id = params[:user_id]
    @sort = params[:sort]
    @tag_id = params[:tag_id]

    # ユーザー一覧を取得（フィルタ用）
    @users = User.all

    @tags = Tag.popular.limit(5)

    @posts = Post.search(keyword: @keyword, user_id: @user_id, tag_id: @tag_id, sort: @sort)
                 .includes(:user, :likes, :tags)
                 .page(params[:page])
                 .per(10)
  end

  def show
    # @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
    @tags = Tag.all
  end

  def edit
    @tags = Tag.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:notice] = t('posts.created')
      redirect_to posts_path, status: :see_other
    else
      @tags = Tag.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = t('posts.updated')
      redirect_to @post, status: :see_other
    else
      @tags = Tag.all
      render :edit, status: :unprocessable_entity
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
    params.expect(post: [:title, :content, :tag_list])
  end

  def find_post
    @post = Post.find_by(id: params[:id])
    redirect_to posts_path, alert: t('posts.not_found') unless @post
  end

  def authorize_user!
    redirect_to posts_path, alert: t('posts.not_authorized') unless @post.user == current_user
  end
end

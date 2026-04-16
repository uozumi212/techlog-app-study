class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }

  # 検索用スコープ
  scope :search_by_title, ->(query) { where('posts.title LIKE ?', "%#{query}%") if query.present? }
  scope :search_by_content, ->(query) { where('posts.content LIKE ?', "%#{query}%") if query.present? }
  scope :by_user, ->(user_id) { where(user_id: user_id) if user_id.present? }
  scope :by_tag, ->(tag_id) { joins(:post_tags).where(post_tags: { tag_id: tag_id }) if tag_id.present? }
  scope :recent, -> { order('posts.created_at DESC') }
  scope :oldest, -> { order('posts.created_at ASC') }

  # 複合検索メソッド
  def self.search(params)
    query = self

    if params[:keyword].present?
      keyword = params[:keyword]
      query = query.where('posts.title LIKE ? OR posts.content LIKE ?',
                          "%#{keyword}%",
                          "%#{keyword}%")
    end

    query = query.by_user(params[:user_id]) if params[:user_id].present?
    query = query.by_tag(params[:tag_id]) if params[:tag_id].present?

    if params[:sort] == 'oldest'
      query.oldest
    else
      query.recent
    end
  end

  # タグ文字列から Tag オブジェクトを生成
  def tag_list=(names)
    tag_names = names.to_s.split(',').map(&:strip).reject(&:blank?).uniq
    self.tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
  end

  # いいね機能のメソッド
  def liked_by?(user)
    return false if user.blank?

    likes.exists?(user_id: user.id)
  end

  delegate :count, to: :likes, prefix: true
end

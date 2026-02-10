class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }

  # 検索用スコープ
  scope :search_by_title, ->(query) { where('title LIKE ?', "%#{query}%") if query.present? }
  scope :search_by_content, ->(query) { where('content LIKE ?', "%#{query}%") if query.present? }
  scope :by_user, ->(user_id) { where(user_id: user_id) if user_id.present? }
  scope :by_tag, ->(tag_id) { joins(:tags).where(tags: { id: tag_id }).distinct if tag_id.present? }
  scope :recent, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }

  # 複合検索メソッド
  def self.search(params)
    query = self

    # キーワード検索（タイトルまたは内容）
    if params[:keyword].present?
      keyword = params[:keyword]
      query = query.where('title LIKE ? OR content LIKE ?', "%#{keyword}%", "%#{keyword}%")
    end

    # ユーザーフィルタ
    query = query.by_user(params[:user_id]) if params[:user_id].present?

    # タグフィルタ
    query = query.by_tag(params[:tag_id]) if params[:tag_id].present?
    
    # ソート順の適用
    if params[:sort] == 'oldest'
      query.oldest
    else
      query.recent
    end
  end
  
  def tag_list=(names)
  	self.tags = names.split(',').map { |name| Tag.find_or_create_by(name: name.strip) }
  end
  
  def tag_list
  	tags.pluck(:name).join(', ')
  end
end

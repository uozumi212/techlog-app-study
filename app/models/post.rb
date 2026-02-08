class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }

  # 検索用スコープ
  scope :search_by_title, ->(query) { where('title LIKE ?', "%#{query}%") if query.present? }
  scope :search_by_content, ->(query) { where('content LIKE ?', "%#{query}%") if query.present? }
  scope :by_user, ->(user_id) { where(user_id: user_id) if user_id.present? }
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

    # query = query.search_by_title(params[:keyword]) if params[:keyword].present?
    query = query.by_user(params[:user_id]) if params[:user_id].present?

    # ソート順の適用
    if params[:sort] == 'oldest'
      query.oldest
    else
      query.recent
    end
  end
end

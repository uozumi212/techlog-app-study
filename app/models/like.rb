class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :post_id, uniqueness: { scope: :user_id, message: "は1つの投稿に対して1回のみいいねできます" }
end

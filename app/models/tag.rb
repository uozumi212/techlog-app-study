class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true, length: { minimum: 1, maximum: 50 }, uniqueness: true

  scope :popular, -> { joins(:post_tags).group('tags.id').order('COUNT(post_tags.id) DESC') }
  scope :recent, -> { order(created_at: :desc) }
end

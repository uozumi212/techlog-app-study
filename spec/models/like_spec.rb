require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe 'associations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it 'post_id と user_id の組み合わせが一意である' do
      # 既存レコードを作成
      create(:like, post: post, user: user)

      # 同じ組み合わせで新規レコードを作成しようとするとエラー
      duplicate_like = build(:like, post: post, user: user)
      expect(duplicate_like).not_to be_valid
      expect(duplicate_like.errors[:post_id]).to be_present
    end
  end

  describe 'like creation' do
    it 'ユーザーが投稿をいいねできる' do
      expect { Like.create!(post: post, user: user) }
        .to change(Like, :count).by(1)
    end

    it '同じユーザーが同じ投稿に2回いいねはできない' do
      Like.create!(post: post, user: user)
      expect { Like.create!(post: post, user: user) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end

    it '異なるユーザーは同じ投稿をいいねできる' do
      other_user = create(:user)

      Like.create!(post: post, user: user)
      expect { Like.create!(post: post, user: other_user) }
        .to change(Like, :count).by(1)
    end

    it '同じユーザーは異なる投稿をいいねできる' do
      other_post = create(:post)

      Like.create!(post: post, user: user)
      expect { Like.create!(post: other_post, user: user) }
        .to change(Like, :count).by(1)
    end
  end

  describe 'like deletion' do
    it 'いいねを削除できる' do
      like = create(:like, post: post, user: user)
      expect { like.destroy }
        .to change(Like, :count).by(-1)
    end

    it 'いいね削除時に投稿は削除されない' do
      like = create(:like, post: post, user: user)
      like.destroy
      expect(Post.find(post.id)).to be_present
    end
  end
end

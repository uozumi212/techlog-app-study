require 'rails_helper'

describe Post do
  before { @user = create(:user) } # 事前にユーザーを作成

  let(:title) { 'テストタイトル' }
  let(:content) { 'テスト本文' }
  let(:user_id) { @user.id } # 作成したユーザーのIDを外部キーに設定

  describe 'バリデーションの検証' do
    let(:post) { Post.new(title: title, content: content, user_id: user_id) }

    context '正常系' do
      it '有効である' do
        expect(post.valid?).to be(true)
      end
    end

    context '異常系' do
      context 'titleが空の場合' do
        let(:title) { nil }
        it '無効である' do
          expect(post.valid?).to be(false)
          expect(post.errors[:title]).to include('が入力されていません。')
        end
      end

      context 'titleが100文字を超える場合' do
        let(:title) { 'あ' * 101 }
        it '無効である' do
          expect(post.valid?).to be(false)
        end
      end

      context 'contentが空の場合' do
        let(:content) { nil }
        it '無効である' do
          expect(post.valid?).to be(false)
          expect(post.errors[:content]).to include('が入力されていません。')
        end
      end

      context 'contentが1000文字を超える場合' do
        let(:content) { 'あ' * 1001 }
        it '無効である' do
          expect(post.valid?).to be(false)
        end
      end

      context 'user_idが空の場合' do
        let(:user_id) { nil }
        it '無効である' do
          expect(post.valid?).to be(false)
          expect(post.errors[:user]).to include('が入力されていません。')
        end
      end
    end
  end

  describe 'Postが持つ情報の検証' do
    before { create(:post, title: title, content: content, user_id: user_id) } # Post を作成

    subject { described_class.first }

    it 'Postの属性値を返す' do
      expect(subject.title).to eq('テストタイトル')
      expect(subject.content).to eq('テスト本文')
      expect(subject.user_id).to eq(@user.id)
    end
  end
end

describe 'tag_list' do
  let(:post) { create(:post) }

  it 'カンマ区切りでタグ追加' do
    post.tag_list = 'Ruby, Rails, Web開発'
    post.save
    expect(post.tags.pluck(:name)).to eq(%w[Ruby Rails Web開発])
  end

  it 'カンマ区切りでタグ追加' do
    post.tags << create(:tag, name: 'Ruby')
    post.tags << create(:tag, name: 'Rails')
    expect(post.tag_list).to eq('Ruby, Rails')
  end
end

describe 'like methods' do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:post) { create(:post) }

  describe '#liked_by?' do
    it 'ユーザーがいいねしていればtrue' do
      post.likes.create!(user: user1)
      expect(post.liked_by?(user1)).to be true
    end

    it 'ユーザーがいいねしていなければfalse' do
      expect(post.liked_by?(user1)).to be false
    end

    it 'userがnilの場合はfalse' do
      expect(post.liked_by?(nil)).to be false
    end
  end

  describe '#likes_count' do
    it 'いいね数を返す' do
      post.likes.create!(user: user1)
      post.likes.create!(user: user2)
      expect(post.likes_count).to eq(2)
    end

    it 'いいねがない場合は0を返す' do
      expect(post.likes_count).to eq(0)
    end
  end
end

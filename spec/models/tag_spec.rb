require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'associations' do
  	it { is_expected.to have_many(:post_tags).dependent(:destroy) }
    it { is_expected.to have_many(:posts).through(:post_tags) }
  end
  
  describe 'validations' do
  	it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(1).is_at_most(50) }

    it 'タグ名の一意かどうかを検証' do
    	create(:tag, name: 'Ruby')
     	duplicate_tag = build(:tag, name: 'Ruby')
      expect(duplicate_tag).not_to be_valid
      expect(duplicate_tag.errors[:name]).to include('は既に使用されています。')
    end
  end
  
  describe 'scopes' do
  	let!(:tag1) { create(:tag, name: 'Ruby') }
  	let!(:tag2) { create(:tag, name: 'Rails') }
   
  	let!(:post1) { create(:post, tags: [tag1]) }
  	let!(:post2) { create(:post, tags: [tag1, tag2]) }
    
   it '人気順（投稿数が多い順）でタグを取得' do
   		popular_tags = Tag.popular.to_a
   		expect(popular_tags.first).to eq(tag1)
   		expect(popular_tags.second).to eq(tag2)
   end
   
   it '最新順でタグを取得' do
   		recent_tags = Tag.recent.to_a
   		expect(recent_tags.first).to eq(tag2)
   		expect(recent_tags.second).to eq(tag1)
   end
  end
  
  describe 'tag creation' do
    it '有効な属性で新しいタグを作成' do
      tag = Tag.new(name: 'Testing')
      expect(tag).to be_valid
    end

    it '空のタグ名は無効' do
      tag = Tag.new(name: '')
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to be_present
    end

    it 'タグを重複して登録は無効' do
      create(:tag, name: 'Ruby')
      duplicate_tag = Tag.new(name: 'Ruby')
      expect(duplicate_tag).not_to be_valid
      expect(duplicate_tag.errors[:name]).to be_present
    end

    it '50文字以上でタグ名は無効' do
      long_name = 'a' * 51
      tag = Tag.new(name: long_name)
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to be_present
    end
  end
  
  describe 'tag associations' do
    it 'タグに紐付いた投稿を取得できる' do
      tag = create(:tag, name: 'Ruby')
      post1 = create(:post, tags: [tag])
      post2 = create(:post, tags: [tag])
      
      expect(tag.posts.count).to eq(2)
      expect(tag.posts).to include(post1, post2)
    end

    it '複数タグを持つ投稿をタグから取得できる' do
      tag1 = create(:tag, name: 'Ruby')
      tag2 = create(:tag, name: 'Rails')
      post = create(:post, tags: [tag1, tag2])
      
      expect(tag1.posts).to include(post)
      expect(tag2.posts).to include(post)
    end

    # it 'タグを削除すると関連の PostTag も削除される' do
    #   tag = create(:tag, name: 'Ruby')
    #   post = create(:post, tags: [tag])
      
    #   expect { tag.destroy }.to change(PostTag, :count).by(-1)
    # end
  end
end

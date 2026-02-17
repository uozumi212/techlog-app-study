require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(500) }
  end

  describe '作成' do
    let(:user) { create(:user) }
    let(:post_record) { create(:post, user: user) }
    let(:comment) { create(:comment, user: user, post: post_record) }

    it '有効なコメントが作成できる' do
      expect(comment).to be_valid
    end

    it '空白のコメントは保存されない' do
      invalid_comment = build(:comment, content: '')
      expect(invalid_comment).not_to be_valid
    end

    it '500文字を超えるコメントは保存されない' do
      invalid_comment = build(:comment, content: 'a' * 501)
      expect(invalid_comment).not_to be_valid
    end
  end
end

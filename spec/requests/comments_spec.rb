require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post_record) { create(:post, user: user) }

  describe 'POST /posts/:post_id/comments' do
    context 'ログイン後' do
      before { sign_in user }

      it 'コメント作成後リダイレクト' do
        expect do
          post post_comments_path(post_record), params: { comment: { content: 'Nice post!' } }
        end.to change(Comment, :count).by(1)

        expect(response).to redirect_to(post_path(post_record))
        follow_redirect!
        expect(response.body).to include(I18n.t('comments.created'))
      end

      it 'コメントを空白で送信時にエラーメッセージが表示される' do
        expect do
          post post_comments_path(post_record), params: { comment: { content: '' } }
        end.not_to change(Comment, :count)

        expect(response).to redirect_to(post_path(post_record))
        follow_redirect!
        # バリデーションエラーメッセージが含まれていることを確認
        expect(response.body).to include('コメントが入力されていません。')
      end

      it '500文字を超えるコメントはエラーメッセージが表示される' do
        expect do
          post post_comments_path(post_record), params: { comment: { content: 'a' * 501 } }
        end.not_to change(Comment, :count)

        expect(response).to redirect_to(post_path(post_record))
      end
    end

    context '未ログイン時' do
      it '会員登録にリダイレクト' do
        post post_comments_path(post_record), params: { comment: { content: 'Hello' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    context 'コメント投稿者でログイン' do
      let!(:comment) { create(:comment, post: post_record, user: user, content: 'Owner comment') }
      before { sign_in user }

      it 'コメント削除後にリダイレクトかつ成功メッセージが表示される' do
        expect do
          delete post_comment_path(post_record, comment)
        end.to change(Comment, :count).by(-1)

        expect(response).to redirect_to(post_path(post_record))
        follow_redirect!
        expect(response.body).to include(I18n.t('comments.deleted'))
      end
    end

    context '他のユーザーでログイン' do
      let!(:comment) { create(:comment, post: post_record, user: user, content: 'Owner comment') }
      before { sign_in other_user }

      it 'コメント削除不可でrootにリダイレクトかつエラーメッセージが表示される' do
        expect do
          delete post_comment_path(post_record, comment)
        end.not_to change(Comment, :count)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include(I18n.t('comments.not_authorized'))
      end
    end

    context '未ログイン時' do
      let!(:comment) { create(:comment, post: post_record, user: user, content: 'Owner comment') }

      it '会員登録にリダイレクト' do
        delete post_comment_path(post_record, comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

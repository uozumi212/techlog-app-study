# spec/requests/posts_spec.rb
require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  before do
    @user = create(:user)
    @other_user = create(:user)
    @post = create(:post, user: @user)
  end

  describe 'GET /posts' do
    context 'ログインしていない場合' do
      it 'HTTPステータス200を返す' do
        get '/posts'
        expect(response).to have_http_status(200)
      end

      it '投稿一覧が表示される' do
        get '/posts'
        expect(response.body).to include('学習ログ一覧')
      end
    end

    context 'ログインしている場合' do
      before { sign_in @user }

      it 'HTTPステータス200を返す' do
        get '/posts'
        expect(response).to have_http_status(200)
      end

      it '投稿一覧が表示される' do
        get '/posts'
        expect(response.body).to include('学習ログ一覧')
      end
    end
  end

  describe 'GET /posts/new' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        get '/posts/new'
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされる' do
        get '/posts/new'
        # Deviseのデフォルト動作：ログインページにリダイレクト
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインしている場合' do
      before { sign_in @user }

      it 'HTTPステータス200を返す' do
        get '/posts/new'
        expect(response).to have_http_status(200)
      end

      it '新規投稿ページが表示される' do
        get '/posts/new'
        expect(response.body).to include('学習ログ投稿')
      end
    end
  end

  describe 'POST /posts' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        post '/posts', params: { post: { title: 'テスト', content: 'テスト内容' } }
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされる' do
        post '/posts', params: { post: { title: 'テスト', content: 'テスト内容' } }
        # Deviseのデフォルト動作：ログインページにリダイレクト
        expect(response).to redirect_to(new_user_session_path)
      end

      it '投稿が作成されない' do
        expect do
          post '/posts', params: { post: { title: 'テスト', content: 'テスト内容' } }
        end.not_to change(Post, :count)
      end
    end

    context 'ログインしている場合' do
      before { sign_in @user }

      context '有効なパラメータの場合' do
        it '新しい投稿が作成される' do
          expect do
            post '/posts', params: { post: { title: 'テスト投稿', content: 'テスト内容です' } }
          end.to change(Post, :count).by(1)
        end

        it '投稿一覧ページにリダイレクトされる' do
          post '/posts', params: { post: { title: 'テスト投稿', content: 'テスト内容です' } }
          expect(response).to redirect_to(posts_path)
        end

        it 'フラッシュメッセージが表示される' do
          post '/posts', params: { post: { title: 'テスト投稿', content: 'テスト内容です' } }
          expect(flash[:notice]).to eq('投稿しました')
        end

        it '投稿者が現在のユーザーに設定される' do
          post '/posts', params: { post: { title: 'テスト投稿', content: 'テスト内容です' } }
          expect(Post.last.user).to eq(@user)
        end
      end

      context '無効なパラメータの場合' do
        it '投稿が作成されない' do
          expect do
            post '/posts', params: { post: { title: '', content: '' } }
          end.not_to change(Post, :count)
        end

        it '新規投稿ページが表示される' do
          post '/posts', params: { post: { title: '', content: '' } }
          expect(response.body).to include('学習ログ投稿')
        end

        it 'エラーメッセージが表示される' do
          post '/posts', params: { post: { title: '', content: '' } }
          expect(flash[:alert]).to eq('投稿に失敗しました')
        end
      end

      context 'タイトルが空の場合' do
        it '投稿が作成されない' do
          expect do
            post '/posts', params: { post: { title: '', content: 'テスト内容' } }
          end.not_to change(Post, :count)
        end
      end

      context '本文が空の場合' do
        it '投稿が作成されない' do
          expect do
            post '/posts', params: { post: { title: 'テスト', content: '' } }
          end.not_to change(Post, :count)
        end
      end
    end
  end

  describe 'GET /posts/:id' do
    context 'ログインしていない場合' do
      it 'HTTPステータス200を返す' do
        get "/posts/#{@post.id}"
        expect(response).to have_http_status(200)
      end

      it '投稿内容が表示される' do
        get "/posts/#{@post.id}"
        expect(response.body).to include(@post.title)
      end
    end

    context 'ログインしている場合' do
      before { sign_in @user }

      it 'HTTPステータス200を返す' do
        get "/posts/#{@post.id}"
        expect(response).to have_http_status(200)
      end

      it '投稿内容が表示される' do
        get "/posts/#{@post.id}"
        expect(response.body).to include(@post.title)
      end
    end

    context '存在しない投稿の場合' do
      it '投稿一覧ページにリダイレクトされる' do
        get '/posts/999999'
        expect(response).to redirect_to(posts_path)
      end
    end
  end

  describe 'GET /posts/:id/edit' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        get "/posts/#{@post.id}/edit"
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされる' do
        get "/posts/#{@post.id}/edit"
        # Deviseのデフォルト動作：ログインページにリダイレクト
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインしている場合' do
      context '投稿者が現在のユーザーの場合' do
        before { sign_in @user }

        it 'HTTPステータス200を返す' do
          get "/posts/#{@post.id}/edit"
          expect(response).to have_http_status(200)
        end

        it '投稿内容がフォームに表示される' do
          get "/posts/#{@post.id}/edit"
          expect(response.body).to include(@post.title)
        end
      end

      context '投稿者が現在のユーザーではない場合' do
        before { sign_in @other_user }

        it '投稿一覧ページにリダイレクトされる' do
          get "/posts/#{@post.id}/edit"
          expect(response).to redirect_to(posts_path)
        end

        it 'エラーメッセージが表示される' do
          get "/posts/#{@post.id}/edit"
          expect(flash[:alert]).to eq('権限がありません')
        end
      end
    end
  end

  describe 'PATCH /posts/:id' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        patch "/posts/#{@post.id}", params: { post: { title: '更新', content: '更新内容' } }
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされる' do
        patch "/posts/#{@post.id}", params: { post: { title: '更新', content: '更新内容' } }
        # Deviseのデフォルト動作：ログインページにリダイレクト
        expect(response).to redirect_to(new_user_session_path)
      end

      it '投稿が更新されない' do
        original_title = @post.title
        patch "/posts/#{@post.id}", params: { post: { title: '更新', content: '更新内容' } }
        @post.reload
        expect(@post.title).to eq(original_title)
      end
    end

    context 'ログインしている場合' do
      before { sign_in @user }

      context '投稿者が現在のユーザーの場合' do
        context '有効なパラメータの場合' do
          it '投稿が更新される' do
            patch "/posts/#{@post.id}", params: { post: { title: '更新タイトル', content: '更新内容です' } }
            @post.reload
            expect(@post.title).to eq('更新タイトル')
            expect(@post.content).to eq('更新内容です')
          end

          it '投稿詳細ページにリダイレクトされる' do
            patch "/posts/#{@post.id}", params: { post: { title: '更新タイトル', content: '更新内容' } }
            expect(response).to redirect_to(post_path(@post))
          end

          it 'フラッシュメッセージが表示される' do
            patch "/posts/#{@post.id}", params: { post: { title: '更新タイトル', content: '更新内容' } }
            expect(flash[:notice]).to eq('投稿を更新しました')
          end
        end

        context '無効なパラメータの場合' do
          it '投稿が更新されない' do
            original_title = @post.title
            patch "/posts/#{@post.id}", params: { post: { title: '', content: '' } }
            @post.reload
            expect(@post.title).to eq(original_title)
          end

          it 'エラーメッセージが表示される' do
            patch "/posts/#{@post.id}", params: { post: { title: '', content: '' } }
            expect(flash[:alert]).to eq('更新に失敗しました')
          end
        end
      end

      context '投稿者が現在のユーザーではない場合' do
        before { sign_in @other_user }

        it '投稿一覧ページにリダイレクトされる' do
          patch "/posts/#{@post.id}", params: { post: { title: '更新', content: '更新内容' } }
          expect(response).to redirect_to(posts_path)
        end

        it '投稿が更新されない' do
          original_title = @post.title
          patch "/posts/#{@post.id}", params: { post: { title: '更新', content: '更新内容' } }
          @post.reload
          expect(@post.title).to eq(original_title)
        end

        it 'エラーメッセージが表示される' do
          patch "/posts/#{@post.id}", params: { post: { title: '更新', content: '更新内容' } }
          expect(flash[:alert]).to eq('権限がありません')
        end
      end
    end
  end

  describe 'DELETE /posts/:id' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        delete "/posts/#{@post.id}"
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされる' do
        delete "/posts/#{@post.id}"
        # Deviseのデフォルト動作：ログインページにリダイレクト
        expect(response).to redirect_to(new_user_session_path)
      end

      it '投稿が削除されない' do
        expect do
          delete "/posts/#{@post.id}"
        end.not_to change(Post, :count)
      end
    end

    context 'ログインしている場合' do
      context '投稿者が現在のユーザーの場合' do
        before { sign_in @user }

        it '投稿が削除される' do
          post_to_delete = create(:post, user: @user)
          expect do
            delete "/posts/#{post_to_delete.id}"
          end.to change(Post, :count).by(-1)
        end

        it '投稿一覧ページにリダイレクトされる' do
          delete "/posts/#{@post.id}"
          expect(response).to redirect_to(posts_path)
        end

        it 'フラッシュメッセージが表示される' do
          delete "/posts/#{@post.id}"
          expect(flash[:notice]).to eq('投稿が削除されました')
        end
      end

      context '投稿者が現在のユーザーではない場合' do
        before { sign_in @other_user }

        it '投稿が削除されない' do
          expect do
            delete "/posts/#{@post.id}"
          end.not_to change(Post, :count)
        end

        it '投稿一覧ページにリダイレクトされる' do
          delete "/posts/#{@post.id}"
          expect(response).to redirect_to(posts_path)
        end

        it 'エラーメッセージが表示される' do
          delete "/posts/#{@post.id}"
          expect(flash[:alert]).to eq('権限がありません')
        end
      end
    end
  end
end

describe 'GET /posts with search' do
  let(:user1) { create(:user, nickname: 'テスト太郎') }
  let(:user2) { create(:user, nickname: 'テスト花子') }
  let!(:post1) { create(:post, title: 'Rails入門', content: 'Railsの基礎を学びました', user: user1) }
  let!(:post2) { create(:post, title: 'Ruby基礎', content: 'Rubyの文法を勉強中', user: user1) }
  let!(:post3) { create(:post, title: 'Rails中級', content: 'Railsのアソシエーションを学習', user: user2) }

  context 'キーワード検索の場合' do
    it 'タイトルに一致する投稿が表示される' do
      get '/posts', params: { keyword: 'Rails' }
      expect(response.body).to include('Rails入門')
      expect(response.body).to include('Rails中級')
      expect(response.body).not_to include('Ruby基礎')
    end

    it '内容に一致する投稿が表示される' do
      get '/posts', params: { keyword: 'アソシエーション' }
      expect(response.body).to include('Rails中級')
    end

    it '一致する投稿がない場合はメッセージが表示される' do
      get '/posts', params: { keyword: '存在しないキーワード' }
      expect(response.body).to include('該当する投稿はありません')
    end
  end

  context 'ユーザーフィルタの場合' do
    it '指定したユーザーの投稿のみ表示される' do
      get '/posts', params: { user_id: user1.id }
      expect(response.body).to include('Rails入門')
      expect(response.body).to include('Ruby基礎')
      expect(response.body).not_to include('Rails中級')
    end
  end

  context 'ソート機能の場合' do
    it 'デフォルトは最新順' do
      get '/posts'
      # 投稿順序を確認（post3が最後に作成されているはず）
      expect(response.body.index('Rails中級')).to be < response.body.index('Rails入門')
    end

    it '古い順でソートできる' do
      get '/posts', params: { sort: 'oldest' }
      # post1が最初に表示されることを確認
      expect(response.body.index('Rails入門')).to be < response.body.index('Rails中級')
    end
  end

  context '複合検索の場合' do
    it 'キーワードとユーザーで絞り込める' do
      get '/posts', params: { keyword: 'Rails', user_id: user1.id }
      expect(response.body).to include('Rails入門')
      expect(response.body).not_to include('Rails中級')
    end
  end
end

describe 'GET /posts with pagination' do
  let!(:posts) { create_list(:post, 25) }

  context 'ページネーション機能' do
    it 'デフォルトは1ページ目を表示' do
      get '/posts'
      expect(response).to have_http_status(200)
      expect(assigns(:posts).current_page).to eq(1)
    end

    it '1ページあたり10件を表示' do
      get '/posts'
      expect(assigns(:posts).size).to eq(10)
    end

    it '2ページ目を表示できる' do
      get '/posts', params: { page: 2 }
      expect(assigns(:posts).current_page).to eq(2)
      expect(assigns(:posts).size).to eq(10)
    end

    it '3ページ目を表示できる' do
      get '/posts', params: { page: 3 }
      expect(assigns(:posts).current_page).to eq(3)
      expect(assigns(:posts).size).to eq(5) # 25件なので最終ページは5件
    end

    it '合計ページ数が正しく計算される' do
      get '/posts'
      expect(assigns(:posts).total_pages).to eq(3)
    end

    it '合計件数が正しく表示される' do
      get '/posts'
      expect(assigns(:posts).total_count).to eq(25)
    end

    it '検索結果でもページネーションが機能' do
      create(:post, title: 'Rails')
      get '/posts', params: { keyword: 'Rails', page: 1 }
      expect(response).to have_http_status(200)
      expect(assigns(:posts).current_page).to eq(1)
    end
  end
end

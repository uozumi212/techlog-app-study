    require 'rails_helper'
     
    describe 'Post', type: :system do
      let!(:user) { create(:user, nickname: 'テスト太郎') }
    
      before { driven_by :rack_test }
    
      describe 'ログ一覧機能' do
        let!(:post1) { create(:post, title: 'RSpec学習', content: 'System Specを作成した', user: user) }
        let!(:post2) { create(:post, title: 'RSpec学習 2', content: 'System Specを作成した 2', user: user) }
    
        before { visit '/posts' }
    
        it '投稿されたログが一覧で表示されている' do
          expect(page).to have_content('RSpec学習')
          expect(page).to have_content('RSpec学習 2')
          expect(page).to have_content('テスト太郎')
        end
    
        it '投稿タイトルをクリックすると詳細ページへ遷移する' do
          click_link 'RSpec学習'
          expect(current_path).to eq("/posts/#{post1.id}")
        end
      end
    
      describe 'ログ詳細機能' do
        let!(:post) { create(:post, title: 'RSpec学習', content: 'System Specを作成した', user: user) }
    
        before { visit "/posts/#{post.id}" }
    
        it 'Postの詳細が表示される' do
          expect(page).to have_content('RSpec学習')
          expect(page).to have_content('System Specを作成した')
          expect(page).to have_content('テスト太郎')
        end
      end
    
      describe 'ログ投稿機能' do
        let(:title) { 'テストタイトル' }
        let(:content) { 'テスト本文' }
    
        subject do
          fill_in 'post_title', with: title
          fill_in 'post_content', with: content
          click_button 'ログを記録'
        end
    
        context 'ログインしていない場合' do
          before { visit '/posts/new' }
    
          it 'ログインページへリダイレクトする' do
            expect(current_path).to eq('/users/sign_in')
            expect(page).to have_content('ログインしてください。')
          end
        end
    
        context 'ログインしている場合' do
          before do
            sign_in user
            visit '/posts/new'
          end
    
          it '投稿ページへアクセスできる' do
            expect(current_path).to eq('/posts/new')
          end
    
          context 'パラメータが正常な場合' do
            it 'Postを作成できる' do
              expect { subject }.to change(Post, :count).by(1)
              expect(current_path).to eq('/posts')
              expect(page).to have_content('投稿しました')
            end
          end
    
          context 'パラメータが異常な場合' do
            let(:title) { '' } # タイトルを空にする
    
            it 'Postを作成できない' do
              expect { subject }.not_to change(Post, :count)
              expect(page).to have_content('投稿に失敗しました')
            end
    
            it '入力していた内容は維持される' do
              subject
              expect(page).to have_field('post_content', with: content)
            end
          end
        end
      end
    end

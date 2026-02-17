puts "ダミーデータの作成を開始します..."

# ユーザーデータの作成
users = []
5.times do |i|
	email = "user#{i + 1}@example.com"
  
  # find_or_create_by! を使うことで、メールアドレスが既にあればそのユーザーを返し、
  # なければブロック内の処理（nickname等）を実行して新規作成します。
  user = User.find_or_create_by!(email: email) do |u|
    u.nickname = "テストユーザー#{i + 1}"
    u.password = "password123"
    u.password_confirmation = "password123"
  end
  users << user
  puts "ユーザー作成: #{user.nickname}"
end

# タグの作成
tag_names = ['Ruby', 'Rails', 'RSpec', 'PostgreSQL', 'Docker', 'Git', 'JavaScript', 'React', 'API設計']
tags = tag_names.map { |name| Tag.find_or_create_by!(name: name) }
puts "Tags 作成: #{tags.count}"

# 投稿データの作成
post_titles = [
  'Rails入門 - セットアップから初期構築まで',
  'Rubyの基本文法を完全マスター',
  'ActiveRecord の関連付けを徹底解説',
  'RESTful APIの設計パターン',
  'RSpec でテストコードを書く',
  'Deviseで認証機能を実装',
  'Railsのセキュリティベストプラクティス',
  'データベース設計のコツ',
  'パフォーマンス最適化テクニック',
  'Docker を使った Rails 開発環境',
  'GitHub Actions で CI/CD を構築',
  'GraphQL を Rails で実装する'
]

post_contents = [
  'Railsの環境構築から初めてのアプリケーション作成までの手順を詳しく解説します。',
  'Rubyの基本的な文法、データ型、制御構文について学習しました。',
  'User と Post の1対多の関連付けについて学びました。',
  'RESTful な API 設計のベストプラクティスについて勉強しました。',
  'RSpec を使ったテストコードの書き方を習得しました。',
  'Devise gemを使ってユーザー認証機能を実装しました。',
  'Rails アプリケーションのセキュリティについて学習しました。',
  'データベースの正規化とスキーマ設計について考察しました。',
  'N+1問題の解決方法とクエリの最適化テクニックを習得しました。',
  'Docker を使った開発環境の構築方法を習得しました。',
  'GitHub Actions を使った自動テストとデプロイの設定を完了しました。',
  'GraphQL を使った API 設計の手法について学習しました。'
]

post_count = 0
users.each_with_index do |user, user_index|
	5.times do |post_index|
		post = Post.find_or_create_by!(
			user: user,
			title: post_titles[(user_index * 5 + post_index) % post_titles.length]
		) do |p|
			p.content = post_contents[(user_index * 5 + post_index) % post_contents.length]
			p.tags = tags.sample(rand(3..5))
		end
		post_count += 1
		puts "投稿作成： #{post.title} (ユーザー: #{user.nickname})"
	end
end

puts "ダミーデータの作成が完了しました！"
puts "ユーザー数: #{User.count}"
puts "投稿数: #{Post.count}"
puts "タグ数：#{Tag.count}"

puts "コメントの作成を開始します"

all_users = User.all.to_a
all_posts = Post.all.to_a

all_posts.each do |p|
	rand(1..3).times do
		commenter = all_users.sample
		Comment.create!(
			post: p,
			user: commenter,
			content: Faker::Lorem.sentence(word_count: 8)
		)
	end
end

puts "コメント作成が完了しました。コメント数： #{Comment.count}"

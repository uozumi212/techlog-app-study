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

# --- タグ作成 ---
puts "--- タグ作成開始 ---"
tag_names = ['Ruby', 'Rails', 'RSpec', 'PostgreSQL', 'Docker', 'Git', 'JavaScript', 'React', 'API設計']
tags = []
tag_names.each do |name|
  begin
    tag = Tag.find_or_create_by!(name: name)
    tags << tag
  rescue => e
    puts "エラー: タグ '#{name}' の作成に失敗しました - #{e.message}"
  end
end
puts "--- タグ作成完了"

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

# 学習ログアプリに適したコメントテンプレート
comment_templates = [
  "参考になりました！自分も同じところで躓いていました。",
  "わかりやすく説明してくれてありがとうございます！",
  "この学習方法、試してみたいと思います。",
  "素晴らしい投稿ですね。共有ありがとうございます。",
  "このトピックについてもっと詳しく知りたいです。良い記事ですね。",
  "同じように学習中です。励みになります！",
  "実装例がとても分かりやすいですね。参考にさせていただきます。",
  "このアプローチは勉強になります。ありがとうございました。",
  "私も同じエラーに遭遇しました。解決策をありがとうございます。",
  "テンポよく学習が進められますね。素晴らしい！",
  "これは知りませんでした。新しい視点をありがとうございます。",
  "詳しい説明をしていただき、ありがとうございました。",
  "実務的で非常に参考になります。",
  "このやり方は効率的ですね。取り入れてみます。",
  "初心者でも理解しやすいです。良い投稿ですね。",
  "実装してみたら、うまくいきました。ありがとう！",
  "このテクニックは便利ですね。今度使ってみます。",
  "説明が丁寧でいいですね。勉強になります。",
  "これをベースに自分のプロジェクトで試してみます。",
  "悩んでいたことがここで解決しました。感謝です！"
]

all_posts.each do |p|
  rand(1..4).times do
    # コメント投稿者が記事の投稿者と異なるようにする
    commenter = (all_users - [p.user]).sample
    
    # 投稿のタグに関連したコメント
    comment_content = if p.tags.any?
      tag_names = p.tags.pluck(:name).sample(2).join("・")
      random_template = comment_templates.sample
      "#{tag_names}について: #{random_template}"
    else
      comment_templates.sample
    end
    
    Comment.create!(
      post: p,
      user: commenter,
      content: comment_content
    )
    puts "コメント作成: #{commenter.nickname} → #{p.title.truncate(30)}"
  end
end

puts "コメント作成が完了しました。コメント数： #{Comment.count}"

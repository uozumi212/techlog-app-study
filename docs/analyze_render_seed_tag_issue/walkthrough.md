# 修正内容の確認 (Walkthrough)

Render環境でタグが反映されない問題を修正しました。

## 実施した変更内容

### [seeds.rb](file:///Users/uozumikazuma/Desktop/udemy/workspace/techlog-app/db/seeds.rb) の修正

`find_or_create_by!` の挙動に基づき、既存データがある場合にタグ割り当てがスキップされないよう変更しました。

```ruby
# 修正前：ブロック内にあるため、新規作成時（初回）しか実行されない
post = Post.find_or_create_by!(...) do |p|
  p.tags = tags.sample(rand(3..5))
end

# 修正後：ブロック外で実行するため、既存データでもタグがなければ割り当てる
post = Post.find_or_create_by!(...)
if post.tags.empty?
  post.update!(tags: tags.sample(rand(3..5)))
end
```

## 確認手順

### 1. ローカルでの確認
以下のコマンドを実行して、エラーが出ないこと、およびタグが割り当てられるログが出ることを確認してください。

```bash
# 既存のデータを保持したままシードを再実行
bundle exec rails db:seed
```

### 2. Renderでの確認
GitHubにプッシュした後、Renderの管理画面から以下の操作を行ってください。

1. **Deploy**: "Manual Deploy" -> "Clear Build Cache & Deploy" を選択。
2. **Logs**: デプロイログの中で `db:seed` が実行され、`タグの割り当て: ...` というログが出力されているか確認。
3. **ブラウザ**: アプリケーションを開き、投稿にタグが表示されていることを確認。

> [!IMPORTANT]
> Renderの設定でデプロイ時に `db:seed` が走るようになっている必要があります。もし設定されていない場合は、Renderの管理画面の "Shell" から `bundle exec rails db:seed` を手動で一度実行することでも解決できます。

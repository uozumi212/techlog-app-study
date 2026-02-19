# Techlog App

技術ブログを投稿・共有できるRailsアプリケーションです。ユーザーは自分の技術記事を公開し、他のユーザーの記事を閲覧できます。

## 📋 プロジェクト概要

Techlog Appは、技術者が知識を共有するためのプラットフォームです。ユーザー認証、投稿管理、プロフィール表示などの基本機能を備えています。

### 主な特徴
- 🔐 ユーザー認証機能（登録・ログイン・ログアウト）
- 📝 投稿の作成・表示・削除機能
- ✨ タグ付けによる投稿の分類
- ❤️ いいね機能によるリアクション
- 💬 コメント機能によるディスカッション
- 🔍 キーワード検索とソート機能
- 👤 ユーザープロフィール表示
- 🎨 レスポンシブデザイン（Tailwind CSS）
- 🚀 最新のRails技術スタックを採用

---

## 🛠 技術スタック

| カテゴリ | 技術 | バージョン |
|---------|------|-----------|
| **言語** | Ruby | 3.3.3 |
| **フレームワーク** | Rails | 8.1.2 |
| **DB（開発）** | SQLite3 | >= 2.1 |
| **DB（本番）** | PostgreSQL | - |
| **認証** | Devise | - |
| **UI Framework** | Tailwind CSS | - |
| **JavaScript** | Hotwire (Turbo + Stimulus) | - |
| **テスト** | RSpec | - |
| **テストデータ** | FactoryBot | - |
| **コード品質** | RuboCop | - |
| **セキュリティ** | Brakeman, Bundler Audit | - |
| **デプロイ** | Docker + Kamal | - |

---

## 📦 システム要件

- **Ruby**: 3.3.3以上
- **Rails**: 8.1.2以上
- **Node.js**: 18以上（JavaScriptバンドラーのため）
- **Bundler**: 2.0以上
- **PostgreSQL**: 本番環境のみ必須

### 開発環境での動作確認済み
- macOS

---

## 🚀 セットアップ手順

### 1. リポジトリをクローン
```bash
git clone <repository-url>
cd techlog-app
```

### 2. 依存gemをインストール
```bash
bundle install
```

### 3. データベースをセットアップ
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed  # オプション：サンプルデータの挿入
```

### 4. マスターキーの設定
本番環境用のマスターキーが必要な場合：
```bash
cp config/master.key.example config/master.key
# master.keyの内容を設定
```

### 5. 開発サーバーを起動
```bash
bin/dev
```

ブラウザで `http://localhost:3000` にアクセスしてください。

---

## 📖 使用方法

### ユーザー登録
1. トップページの「サインアップ」リンクをクリック
2. メールアドレス、パスワード、ニックネームを入力
3. 「登録」ボタンをクリック

### 投稿の作成
1. ログイン状態で「新規投稿」をクリック
2. タイトル（100字以内）と本文（1000字以内）を入力
3. 「投稿する」ボタンをクリック

### 投稿の表示
- 投稿一覧ページで最新10件の投稿が表示されます
- 各投稿をクリックで詳細ページを表示

### 投稿の編集と更新
- 投稿編集画面で選択した投稿情報がフォームに出力
- 投稿内容を修正して、更新できる

### 投稿の削除
- 自分の投稿の詳細ページの「削除」ボタンから削除可能

### 検索機能
- タイトル、本文の内容で検索可能
- 投稿者名での絞り込みや、投稿日時（新着順・古い順）でのソート可能

### ページネーション
- 投稿一覧は10件ずつ表示され、ページを切り替えて閲覧できます。

### いいね機能
- 自分以外のユーザーの投稿に対して、いいねを付けたりできます。
- いいねの数はリアルタイムで更新されます。

### コメント機能
- 投稿詳細ページでコメントを投稿・表示できます。

---

## 🧪 テスト実行方法

### 全テストを実行
```bash
bundle exec rspec
```

### 特定のファイルのテストを実行
```bash
bundle exec rspec spec/models/post_spec.rb
```

### カバレッジを確認
```bash
COVERAGE=true bundle exec rspec
```

### テストデータベースをリセット
```bash
bin/rails db:test:prepare
```

---

## 📊 データベーススキーマ

### users テーブル
| カラム | 型 | 説明 |
|--------|----|----|
| id | bigint | プライマリキー |
| email | string | ログイン用メールアドレス |
| nickname | string | 表示用ニックネーム（20字以内） |
| encrypted_password | string | 暗号化されたパスワード |
| created_at | datetime | 作成日時 |
| updated_at | datetime | 更新日時 |

### posts テーブル
| カラム | 型 | 説明 |
|--------|----|----|
| id | bigint | プライマリキー |
| user_id | bigint | ユーザーID（外部キー） |
| title | string | 投稿タイトル（100字以内） |
| content | text | 投稿本文（1000字以内） |
| created_at | datetime | 作成日時 |
| updated_at | datetime | 更新日時 |

### likes テーブル
| カラム | 型 | 説明 |
|---|---|---|
| id | bigint | プライマリキー |
| user_id | bigint | ユーザーID（外部キー） |
| post_id | bigint | 投稿ID（外部キー） |
| created_at | datetime | 作成日時 |
| updated_at | datetime | 更新日時 |

### comments テーブル
| カラム | 型 | 説明 |
|---|---|---|
| id | bigint | プライマリキー |
| user_id | bigint | ユーザーID（外部キー） |
| post_id | bigint | 投稿ID（外部キー） |
| content | text | コメント本文 |
| created_at | datetime | 作成日時 |
| updated_at | datetime | 更新日時 |

### tags テーブル
| カラム | 型 | 説明 |
|---|---|---|
| id | bigint | プライマリキー |
| name | string | タグ名（ユニーク） |
| created_at | datetime | 作成日時 |
| updated_at | datetime | 更新日時 |

### post_tags テーブル
| カラム | 型 | 説明 |
|---|---|---|
| id | bigint | プライマリキー |
| post_id | bigint | 投稿ID（外部キー） |
| tag_id | bigint | タグID（外部キー） |
| created_at | datetime | 作成日時 |
| updated_at | datetime | 更新日時 |

---

## 🔐 セキュリティ機能

- Devise による安全なユーザー認証
- パスワード暗号化（bcrypt）
- CSRF対策
- XSS対策（Rails標準）
- SQLインジェクション対策
- 定期的なセキュリティ監査（Brakeman, Bundler Audit）

### セキュリティチェック実行
```bash
bin/brakeman              # セキュリティ脆弱性スキャン
bin/bundler-audit check  # 依存gemの脆弱性チェック
```

---

## 🚧 今後の改善予定機能

### 優先度：低
- [ ] **通知機能** - ユーザーアクティビティの通知
- [ ] **マークダウン対応** - 投稿内容のマークダウン実装

---

## 🔄 開発への貢献

1. フォークをしてください
2. フィーチャーブランチを作成 (`git checkout -b feature/AmazingFeature`)
3. コミット (`git commit -m 'Add some AmazingFeature'`)
4. ブランチにプッシュ (`git push origin feature/AmazingFeature`)
5. プルリクエストを作成

---

### アプリURL
[http://35.75.226.123/](https://techlog-app.xyz/)

**最終更新**: 2026年2月18日

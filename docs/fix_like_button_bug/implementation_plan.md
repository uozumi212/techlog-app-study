# いいね機能の不具合修正計画

ログイン直後にいいねボタンが反応しない問題を修正します。

## 背景と原因
- 現在のいいねボタンは `_like_button.html.erb` 内のインラインスクリプトで制御されています。
- このスクリプトは `DOMContentLoaded` イベントでリスナーを登録していますが、Rails の Turbo 環境ではページ遷移（ログイン後のリダイレクト含む）時にこのイベントが再発火しません。
- すでに `like_controller.js` という Stimulus コントローラーが存在するため、これを使用するように修正することで、Turbo のライフサイクルに合わせて正しく動作するようにします。

## 修正内容

### [Component] いいねボタン

#### [MODIFY] [app/views/posts/_like_button.html.erb](file:///Users/uozumikazuma/Desktop/udemy/workspace/techlog-app/app/views/posts/_like_button.html.erb)
- インラインの `<script>` タグを削除します。
- フォームに `data-controller="like"` および `data-like-target="form"` を追加します。
- ボタンに `data-like-target="button"` および `data-action="click->like#handleSubmit"` を追加します。
- いいね数表示に `data-like-target="count"` を追加します。

## 検証計画

### マニュアル確認
1. ログアウト状態からログイン。
2. ログイン直後のトップページ（またはポスト一覧）でいいねボタンを押下。
3. 画面上のハートの色といいね数が即座に更新されることを確認。
4. ページをリロードして、状態が維持されていることを確認（DB更新の確認）。

> [!NOTE]
> DBの更新自体はすでに行われているとのことなので、フロントエンドのイベントリスナーの登録漏れが解消されれば、正常に動作する見込みです。

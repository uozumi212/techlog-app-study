#!/usr/bin/env bash
# エラーが発生したら即座に終了する
set -o errexit

# 1. Gemのインストール（これが重要！）
bundle install

# 2. アセットのプリコンパイル
bundle exec rails assets:precompile
bundle exec rails assets:clean

# 3. データベースの設定
# 初回のみ db:schema:load が必要ですが、通常は migrate だけでOKです
bundle exec rails db:migrate

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TechlogApp
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])
    
    config.i18n.default_locale = :ja
    
    config.generators do |g| # ここから追記
      g.assets false          # CSS, JavaScriptファイルを自動生成しない
      g.helper false      # helperファイルを自動生成しない
      g.test_framework :rspec # テストフレームワークをrspecに設定
    end  # ここまで追記
  end
end

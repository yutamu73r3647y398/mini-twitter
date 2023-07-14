# 本番環境でUserモデルを使うためにはRender上でもマイグレーションを実行する必要がある。これはそのための設定ファイルである。
#!/usr/bin/env bash
# exit on error
set -o errexit
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

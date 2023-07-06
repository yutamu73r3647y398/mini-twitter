Rails.application.routes.draw do
  # ルート「/」へのGETリクエストをStaticPagesコントローラのhomeアクションにルーティングさせる
  root "static_pages#home"
#   contorollerのhome,helpにルーティング、GETで設定
  get  "static_pages/home"
  get  "static_pages/help"
  get  "static_pages/about"
  get  "static_pages/contact"
end

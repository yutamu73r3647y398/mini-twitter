Rails.application.routes.draw do
  # ルート「/」へのGETリクエストをStaticPagesコントローラのhomeアクションにルーティングさせる
  root "static_pages#home"
  # contorollerのhome,helpにルーティング、名前付きルーティング
  get  "/help",    to: "static_pages#help"
  get  "/about",   to: "static_pages#about"
  get  "/contact", to: "static_pages#contact"
  get  "/signup",  to: "users#new"
end

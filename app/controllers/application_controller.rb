class ApplicationController < ActionController::Base
  # 親クラスであるApplicationコントローラにSessionヘルパーモジュールを読み込む
  include SessionsHelper
  
  private
  
  # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end
end

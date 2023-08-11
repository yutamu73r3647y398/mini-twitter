module SessionsHelper
  
  # 渡されたユーザーでログインする（新規メソッドの作成定義）
  # sessionメソッドはRailsにデフォルト搭載されているメソッド
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 永続セッションのためにユーザーをDBに記憶する
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    # user_id と sesssion[:usser_id]の比較ではなく代入であることに注意
    if (user_id = session[:user_id])
      # メモ化（memoization）
      @current_user ||= User.find_by(id: user_id)
      # 比較ではなく代入
    elsif (user_id = cookies.encrypted[:user_id])
      # raise  #テストがパスすれば、この部分のテストがされていないことが分かる
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  # 永続的にSessionを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil #安全のため
  end

end

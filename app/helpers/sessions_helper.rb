module SessionsHelper
  
  # 渡されたユーザーでログインする（新規メソッドの作成定義）
  
  # sessionメソッドはRailsにデフォルト搭載されているメソッド
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 現在のログイン中のユーザーを返す（いる場合のみ）
  def current_user
    if session[:user_id]
      @current_user = @current_user || User.find_by(id: session[:user_id])
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    reset_session
    @current_user = nil #安全のため
  end

end

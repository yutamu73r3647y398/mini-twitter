class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    #authenticateメソッドは認証に失敗したときにfalseを返す
    if user && user.authenticate(params[:session][:password])
      # セキュリティ対策のため、ログイン直前にセッションをリセット
      reset_session
      # ［remember me］チェックボックスの送信結果を処理する
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      # ユーザーログイン後にユーザー情報のページにリダイレクトする redirect_touser_url(user)と同義
      redirect_to user
    else
      # エラーメッセージを作成する-flash.now
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end
  
  def destroy
    # logged_in?がtrueの場合にもログアウト実行
    log_out if logged_in?
    # Turboを使うためにstatus303 See Otherに指定
    redirect_to root_url, status: :see_other
  end
  
end

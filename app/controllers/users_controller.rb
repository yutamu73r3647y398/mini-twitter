class UsersController < ApplicationController
  
  def show
    @user = User.find_by(params[:id])
    # # debuggerメソッドを差し込む 7章
    # debugger
  end
  
  def new
    @user = User.new
  end
  
  def create
    # User.new の引数にStrong Parametersを使う(user_paramsは下記に定義)
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ゆうたむあいらんどへ ようこそ！"
      # 保存が成功した場合にuser ページに遷移させる（redirect_to user_url(@user)と同等）
      redirect_to @user
    else
      # newアクション に　renderさせる
      # 保存失敗時:HTTPステータスコード422 Unprocessable Entityに対応
      render 'new', status: :unprocessable_entity
    end
  end
  
  # user_params ストロングパラメータの定義
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                   :password_confirmation)
    end
end

class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  # destroyメソッドの保護
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find_by(params[:id])
    # micropostとの関連付け及び、pagenationの設定
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    # User.new の引数にStrong Parametersを使う(user_paramsは下記に定義)
    @user = User.new(user_params)
    if @user.save
      # セキュリティ対策のためログイン前にsessionのリセット
      reset_session
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      # 保存が成功した場合にuser ページに遷移させる（redirect_to user_url(@user)と同等）
      redirect_to @user
    else
      # newアクション に　renderさせる
      # 保存失敗時:HTTPステータスコード422 Unprocessable Entityに対応
      render 'new', status: :unprocessable_entity
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end
  
  # user_params ストロングパラメータの定義
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # beforeフィルタ

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless @user == current_user
    end
    
    # 管理者（admin）か確認
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end

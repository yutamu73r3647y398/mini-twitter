require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  # testする際のユーザー情報の指定
  def setup
    @user = users(:michael)
  end
  
  # フラッシュメッセージの残留をキャッチするテスト
  
  # 無効なユーザーログアウトのテスト
  test "login with valid email/invalid password" do
    get login_path
    # 新しいセッションのフォームが”正しく”表示されるか確認①
    assert_template 'sessions/new'
    # 無効なparamsハッシュをセッション用のパスにPOSTする
    post login_path, params: { session: { email: @user.email, password: "invalid" } }
    assert_not is_logged_in?
    # 新しいフォームが正しいステータスを返し、再表示されることを確認
    assert_response :unprocessable_entity
    # ②
    assert_template 'sessions/new'
    # flashメッセージが表示されるか確認
    assert_not flash.empty?
    # 別のページに移動（例としてroot-path）
    get root_path
    assert flash.empty?
  end
  
  # 有効なユーザーログアウトのテスト
  test "login with valid information followed by logout" do
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
    follow_redirect!
    # loginへのpathがあるか検証
    assert_select "a[href=?]", login_path
    # logout,ユーザーページへのpathが０か検証
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end

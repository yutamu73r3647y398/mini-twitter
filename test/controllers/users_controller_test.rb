require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  # editアクションの保護に対するテスト
  test "should redirect edit when not logged in as wrong user" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url 
  end
  
  # updateアクションの保護に対するテスト
  test "should redirect update when not logged in as wrong user" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url 
  end
  
  # admin属性の変更が禁止されていることをテスト
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  # indexアクションのリダイレクトをテスト
  test "should redirect index when not login" do
    get users_path
    assert_redirected_to login_url
  end
  
  # 管理者権限の制御をアクションレベルでテスト
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end
  
  # 管理者権限の制御をアクションレベルでテスト
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
  
end

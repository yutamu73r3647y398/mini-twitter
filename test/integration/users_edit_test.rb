require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  
  # ログイン環境を作成
  def setup
    @user = users(:michael)
    # remember(@user)
  end
  
  # 編集の失敗に対するテスト
  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    # user_pathに登録失敗する情報を送る、postではなく  patch
    patch user_path(@user), params: { user: { name:  "",
                                       email: "user@invalid",
                                       password:              "foo",
                                       password_confirmation: "bar" } }
    assert_template 'users/edit'
    # 4つの項目に対してエラーメッセージが表示されるかテスト
    assert_select "div.alert", "The form contains 4 errors."
  end
  
  # 編集の成功に対するテスト
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
  
end

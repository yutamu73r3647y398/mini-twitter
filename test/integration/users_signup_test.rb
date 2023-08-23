require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  # 無効なユーザー登録に対するテスト
  test "invalid signup information" do
    # getメソッドを使ってユーザー登録ページにアクセス
    get signup_path
    # assert_no_differenceでuser追加前と追加後のユーザー数の差異を判断
    assert_no_difference 'User.count' do
    post users_path, params: { user: { name:  "",
                                       email: "user@invalid",
                                       password:              "foo",
                                       password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    
    # ユーザーサインアップ失敗時のエラーメッセージに対するtest
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end
  
  # 有効なユーザー登録に対するテスト
  test "valid signup information" do
    # ブロック内の処理の直前と直後でカウント数の差異が１の場合（第２引数に１）
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    # どのテンプレートが表示されているのか検証
    # Userのルーティング、showアクション、show.htmlのビューが正しく動いているかテストする
    assert_template 'users/show'
    # ユーザー登録成功時のflash に対する検証
    assert_not flash.empty?
    assert is_logged_in?
  end
end
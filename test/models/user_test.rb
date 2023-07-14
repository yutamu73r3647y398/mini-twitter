require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  # setupメソッド内で@userを宣言しておけば、全てのtestでこのインスタンス変数が利用可能になる
  # そもそも、このsetupメソッドはなんなの？
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    # @user.valid?
    # @user.errors
    assert @user.valid?
  end
  
  # user　name、emailのバリデーションが機能しているかtest
  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end
  
  test "emmail should be present" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  # name,emailの長さの検証に対するtest
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.name = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  # 有効なメールアドレスフォーマットをテストする
  test "email validation syould accept valid addressess" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  # メールフォーマットの検証に対するtest(カンマや＠がない場合などを跳ね返す)
  # ドットが連続であるアドレスも跳ね返すようにアップデート
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  # 重複するメールアドレス拒否のテスト
  test "email addresses should be unique" do
    # dupメソッドで複製
    duplicate_user = @user.dup
    # 複製されたメールアドレスはすでにDBに同じものが存在するのでvalidが通らないはず
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    # test用に大文字小文字含むアドレスを用意
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  # パスワードの存在性のtest,blankを弾く
  test "password should be present (notblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  # パスワードの最小文字数のtest
  test "password should have a mnimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
end

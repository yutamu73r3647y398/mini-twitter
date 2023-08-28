require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # @micropost = Micropost.new(content: "Lorem ipsm", user_id: @user.id)　以下の1行と同じ意味
    @micropost = @user.microposts.build(content: "Lorem ipsm")
  end

  # micropostがそもそも存在するかテスト
  test "should be valid" do
    assert @micropost.valid?
  end

  # micropost.user_id に対する検証
  test "user_id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  # micropost.contentの存在性の検証
  test "micropost.content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end
  
  # micropost.contentの文字数の検証
  test "micropost.content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  # マイクロポストの順序付けの確認テスト
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end

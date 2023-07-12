require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  # assert_seelect を用いて各ルートへのリンクがあるのかテストする
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    # ルートURLのリンクはロゴとナビバーの合計2つ
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    # title　が合致しているか確認
    get contact_path
    assert_select "title", full_title("Contact")
    # SignUpページへのリンク確認
    get signup_path
    assert_select "title", full_title("Sign up")
  end
end
  
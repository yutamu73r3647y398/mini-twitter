module UsersHelper
  # Viewsのshow.htmlにて引数で与えられたユーザーのGravatar画像を返す
  # gravatar_forメソッドをhelperに定義することでviewsでも使えるようになる
  def gravatar_for(user, options = { size: 80})
    size         = options[:size]
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end

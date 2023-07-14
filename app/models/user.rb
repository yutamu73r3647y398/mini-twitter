class User < ApplicationRecord
  # コールバックメソッドを利用して、DB保存前に小文字に変換する
  before_save { self.email = self.email.downcase }
  # user name,emailのバリデーション
  # かっこの省略可能
  validates :name,  presence: true, length: { maximum: 50 }
  # メールフォーマットを正規表現で検証する
  # ドットが連続で現れるアドレスも跳ね返すようにアプデ済み
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  # Userモデルにhas_secure_passwordを追加する
  has_secure_password
  # passwordのバリデーション
  validates :password, presence:true, length: { minimum: 6 }
end

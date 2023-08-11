class User < ApplicationRecord
  attr_accessor :remember_token
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
  
  # fixture向けのdigestメソッドの追加-渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # トークン生成用メソッド
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためユーザーをDBに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    # digestが存在師な場合にfolseを返す
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end

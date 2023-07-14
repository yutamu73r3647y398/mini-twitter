class AddIndexToUsersEmail < ActiveRecord::Migration[7.0]
  # メールアドレスの一意性を強制するためのマイグレーション
  def change
    add_index :users, :email, unique: true
  end
end

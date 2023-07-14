class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
# t.timestamp により,created_at,updated_atを作成可能
      t.timestamps
    end
  end
end

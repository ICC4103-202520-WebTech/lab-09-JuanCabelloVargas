class DropModels < ActiveRecord::Migration[8.0]
  def up
    drop_table :models, if_exists: true
  end

  def down
    create_table :models do |t|
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :user
      t.timestamps
    end
    add_index :models, :email, unique: true
    add_index :models, :reset_password_token, unique: true
  end
end

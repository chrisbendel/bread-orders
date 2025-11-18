class CreateLoginCodes < ActiveRecord::Migration[8.1]
  def change
    create_table :login_codes do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :code_digest, null: false
      t.datetime :expires_at, null: false
      t.datetime :used_at
      t.timestamps
    end

    add_index :login_codes, [:user_id, :created_at]
  end
end

class CreateStoreNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :store_notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.string :unsubscribe_token

      t.timestamps
    end

    add_index :store_notifications, [:user_id, :store_id], unique: true, name: "index_store_notifications_on_user_and_store"
    add_index :store_notifications, :unsubscribe_token, unique: true
  end
end

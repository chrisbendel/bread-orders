class CreateStoreSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :store_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.string :unsubscribe_token

      t.timestamps
    end

    add_index :store_subscriptions, [:user_id, :store_id], unique: true, name: "index_store_subs_on_user_and_store"
    add_index :store_subscriptions, :unsubscribe_token, unique: true
  end
end

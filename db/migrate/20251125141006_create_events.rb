class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :store, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.datetime :orders_open_at
      t.datetime :orders_close_at
      t.datetime :pickup_at

      t.timestamps
    end
  end
end

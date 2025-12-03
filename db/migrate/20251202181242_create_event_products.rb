class CreateEventProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :event_products do |t|
      t.references :event, null: false, foreign_key: true
      t.string :name
      t.integer :quantity

      t.timestamps
    end
  end
end

class CreateStores < ActiveRecord::Migration[8.1]
  def change
    create_table :stores do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps
    end

    add_index :stores, :slug, unique: true
  end
end

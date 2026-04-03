class AddConfirmedAtToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :confirmed_at, :datetime
    add_index :orders, :confirmed_at
  end
end

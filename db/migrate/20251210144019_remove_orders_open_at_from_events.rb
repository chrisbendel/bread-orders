class RemoveOrdersOpenAtFromEvents < ActiveRecord::Migration[8.1]
  def change
    remove_column :events, :orders_open_at, :datetime
  end
end

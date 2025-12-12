class AddPriceCentsToEventProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :event_products, :price_cents, :integer
  end
end

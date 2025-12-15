class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :event_product

  validates :quantity, numericality: {greater_than: 0, less_than_or_equal_to: 1000}

  before_validation :set_unit_price, on: :create

  private

  def set_unit_price
    self.unit_price_cents ||= event_product.price_cents
  end
end

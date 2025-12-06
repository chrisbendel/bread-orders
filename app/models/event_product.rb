class EventProduct < ApplicationRecord
  belongs_to :event
  has_many :order_items

  validates :name, presence: true, uniqueness: true
  validates :quantity, numericality: {greater_than_or_equal_to: 0}
  validates :price_cents, numericality: {greater_than_or_equal_to: 0}

  def price
    price_cents.to_f / 100
  end

  def price_formatted
    "$%.2f" % price
  end
end

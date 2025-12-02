class Event < ApplicationRecord
  belongs_to :store

  validates :name, presence: true
  validates :orders_open_at, presence: true
  validates :orders_close_at, presence: true
  validates :pickup_at, presence: true

  scope :active, -> { where("orders_close_at > ?", Time.current) }
  # Optional future constraint:
  # validate :close_after_open
  #
  # def close_after_open
  #   if orders_close_at <= orders_open_at
  #     errors.add(:orders_close_at, "must be after the open date")
  #   end
  # end
end

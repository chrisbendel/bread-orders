class EventProduct < ApplicationRecord
  belongs_to :event

  validates :name, presence: true, uniqueness: true
  validates :quantity, numericality: {greater_than_or_equal_to: 0}
end

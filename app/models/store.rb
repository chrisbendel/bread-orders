class Store < ApplicationRecord
  belongs_to :user
  has_many :events, dependent: :destroy

  validates :name, presence: true
  validates :slug,
            presence: true,
            uniqueness: true,
            format: { with: /\A[a-z0-9-]+\z/i }

  # eventually check `user.subscription_active?` when integrating payments
  def monetization_allowed?
    true
  end

  # Placeholder for when orders are implemented
  def active_orders?
    false
  end
end

class StoreNotification < ApplicationRecord
  belongs_to :user
  belongs_to :store

  before_validation :ensure_unsubscribe_token, on: :create

  validates :unsubscribe_token, presence: true, uniqueness: true
  validates :user_id, uniqueness: {scope: :store_id}

  private

  def ensure_unsubscribe_token
    self.unsubscribe_token ||= generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(20)
      break token unless self.class.exists?(unsubscribe_token: token)
    end
  end
end

class User < ApplicationRecord
  before_validation :normalize_email
  before_validation :ensure_username

  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :email, uniqueness: {case_sensitive: false}
  validates :username, presence: false, uniqueness: {case_sensitive: false}, length: {maximum: 50}
  validates :username, format: {with: /
    \A[a-z0-9]+(?:[._-][a-z0-9]+)*\z
  /xi, message: "may only include letters, numbers, and . _ -"}

  def to_param
    username
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def ensure_username
    base = (username.presence || email.to_s.split("@").first.to_s).parameterize(separator: "-")
    base = "user" if base.blank?
    candidate = base
    n = 2
    while self.class.where.not(id: id).exists?(username: candidate)
      candidate = "#{base}-#{n}"
      n += 1
    end
    self.username = candidate
  end
end

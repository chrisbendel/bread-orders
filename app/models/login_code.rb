class LoginCode < ApplicationRecord
  belongs_to :user

  CODE_TTL = 10.minutes
  # How many codes can be requested in this window?
  REQUEST_LIMIT_WINDOW = 1.hour
  REQUEST_LIMIT_COUNT = 5

  attr_reader :plain_code

  before_validation :generate_code_and_digest, on: :create

  validates :code_digest, presence: true
  validates :expires_at, presence: true

  scope :active_for_user, ->(user) { where(user: user).where("used_at IS NULL AND expires_at > ?", Time.current) }

  def self.generate_for(user)
    # optional rate-limit check (basic DB-backed)
    timeframe_start = Time.current - REQUEST_LIMIT_WINDOW
    recent_count = where(user: user).where("created_at > ?", timeframe_start).count
    if recent_count >= REQUEST_LIMIT_COUNT
      raise StandardError, "Too many login requests. Try again later."
    end

    transaction do
      # Optionally: mark previous unused codes as used (invalidate)
      where(user: user).where(used_at: nil).update_all(used_at: Time.current)

      code = new(user: user)
      code.save!
      code.plain_code # return the plain code for sending
      code
    end
  end

  def verify(submitted_code)
    return false if used_at.present?
    return false if expires_at < Time.current

    # BCrypt compare
    if BCrypt::Password.new(code_digest) == submitted_code.to_s
      touch(:used_at)
      true
    else
      false
    end
  end

  private

  def generate_code_and_digest
    # keep 6 digits, leading zeros allowed
    @plain_code = "%06d" % rand(0..999_999)
    self.code_digest = BCrypt::Password.create(@plain_code)
    self.expires_at ||= Time.current + CODE_TTL
  end
end

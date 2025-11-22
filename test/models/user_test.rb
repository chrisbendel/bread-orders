require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes email " do
    user = User.create!(email: "  Alice@Example.COM  ")
    assert_equal "alice@example.com", user.email
  end
end

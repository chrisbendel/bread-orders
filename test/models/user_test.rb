require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes email and generates username" do
    user = User.create!(email: "  Alice@Example.COM  ")
    assert_equal "alice@example.com", user.email
    assert_match(/alice/, user.username)
  end

  test "ensures unique username" do
    u1 = User.create!(email: "bob@example.com")
    u2 = User.create!(email: "bob+2@example.com", username: u1.username)
    assert_not_equal u1.username, u2.username
  end
end

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes email" do
    user = User.create!(email: "  Alice@Example.COM  ")
    assert_equal "alice@example.com", user.email
  end

  test "requires an email" do
    user = User.new(email: "")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "validates email format" do
    user = User.new(email: "not-an-email")
    assert_not user.valid?
    assert_includes user.errors[:email], "is invalid"
  end

  test "enforces unique email (case insensitive)" do
    User.create!(email: "test@example.com")

    dup = User.new(email: "TEST@example.com")

    assert_not dup.valid?
    assert_includes dup.errors[:email], "has already been taken"
  end

  test "has_one :store association" do
    user = User.create!(email: "user@example.com")
    store = user.create_store!(name: "My Store", slug: "my-store")

    assert_equal store, user.store
    assert_equal user, store.user
  end

  test "destroys associated store when user is destroyed" do
    user = User.create!(email: "user@example.com")
    user.create_store!(name: "My Store", slug: "my-store")

    assert_difference -> { Store.count }, -1 do
      user.destroy
    end
  end
end

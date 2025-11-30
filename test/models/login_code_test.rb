require "test_helper"

class LoginCodeTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com")
  end

  test "creates a code with digest and expiry" do
    code = LoginCode.create!(user: @user)

    assert code.code_digest.present?
    assert code.expires_at.present?
    assert code.plain_code.present?
    assert_equal 6, code.plain_code.length
  end

  test "plain_code is only available in-memory" do
    code = LoginCode.generate_for(@user)

    # Available immediately
    assert_match(/\A\d{6}\z/, code.plain_code)

    # After reload, plain_code should be nil
    code_reload = LoginCode.find(code.id)
    assert_nil code_reload.plain_code
  end

  test ".active_for_user returns only unexpired + unused codes" do
    good = LoginCode.create!(user: @user)

    expired = LoginCode.create!(user: @user, expires_at: 5.minutes.ago)
    used = LoginCode.create!(user: @user, used_at: Time.current)

    result = LoginCode.active_for_user(@user)

    assert_includes result, good
    refute_includes result, expired
    refute_includes result, used
  end

  test ".generate_for creates a new code and invalidates previous ones" do
    old = LoginCode.create!(user: @user)
    assert_nil old.used_at

    new_code = LoginCode.generate_for(@user)

    old.reload
    assert old.used_at.present?
    assert new_code.persisted?
    assert new_code.plain_code.present?
  end

  test ".generate_for enforces rate limiting" do
    # hit limit
    LoginCode::REQUEST_LIMIT_COUNT.times do
      LoginCode.generate_for(@user)
    end

    # next call should raise
    assert_raises(StandardError) do
      LoginCode.generate_for(@user)
    end
  end

  test "#verify returns true for correct code and marks used_at" do
    code = LoginCode.generate_for(@user)
    plain = code.plain_code

    assert code.verify(plain)
    assert code.used_at.present?
  end

  test "#verify rejects incorrect code" do
    code = LoginCode.generate_for(@user)

    refute code.verify("wrong123")
    assert_nil code.used_at
  end

  test "#verify rejects expired codes" do
    code = LoginCode.create!(user: @user, expires_at: 1.minute.ago)
    code.instance_variable_set(:@plain_code, "123456") # needed to try a match

    refute code.verify("123456")
  end

  test "#verify rejects already-used codes" do
    code = LoginCode.generate_for(@user)
    plain = code.plain_code

    assert code.verify(plain) # first use
    refute code.verify(plain) # second use
  end
end

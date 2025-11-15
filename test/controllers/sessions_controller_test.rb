require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "send code and sign in with correct code" do
    user = users(:one) # or however you load fixtures
    post session_path, params: {email: user.email}
    assert_redirected_to verify_session_path

    # Grab the created LoginCode
    login_code = LoginCode.where(user: user).order(created_at: :desc).first
    assert_not_nil login_code
    # We don't have the plain code saved in DB; we can circumvent for test by
    # using BCrypt to check or by stubbing generate. For simplicity, create a code manually:
    # NOTE: alternative approaches:
    # - modify LoginCode to expose plain_code on create in test env
    # - or bypass and set a known code via factory / create directly
    #
    # Here we'll create a fresh code with a known value:
    login_code = LoginCode.create!(user: user)
    plain = login_code.plain_code
    # login_code.saved? plain_code generated

    post confirm_session_path, params: {email: user.email, code: plain}
    assert_redirected_to root_path
    follow_redirect!
    assert_select "div", /Signed in/ # or check a flash
    assert_equal user.id, session[:user_id]
  end
end

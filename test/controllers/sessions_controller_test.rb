require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "new redirects when already signed in" do
    user = User.create!(email: "a@example.com")
    sign_in_as(user)

    get new_session_path
    assert_redirected_to dashboard_path
  end

  test "create sends login code and redirects to verify" do
    assert_difference -> { User.count }, 1 do
      post session_path, params: {email: "new@example.com"}
    end

    assert_redirected_to verify_session_path
    assert_not_nil session[:login_email]
  end

  test "confirm signs in with correct code" do
    user = User.create!(email: "code@example.com")

    ActionMailer::Base.deliveries.clear
    post session_path, params: {email: user.email}
    mail = ActionMailer::Base.deliveries.last
    body_text = [mail.subject, mail.text_part&.body&.to_s, mail.html_part&.body&.to_s, mail.body&.to_s].compact.join("\n")
    code = body_text[/\b\d{6}\b/]

    post confirm_session_path, params: {email: user.email, code: code}
    assert_redirected_to root_path
    assert_equal "Signed in!", flash[:notice]
    assert_equal user.id, session[:user_id]
  end

  test "confirm fails with wrong code" do
    user = User.create!(email: "nope@example.com")

    ActionMailer::Base.deliveries.clear
    post session_path, params: {email: user.email}
    post confirm_session_path, params: {email: user.email, code: "wrong"}

    assert_response :unauthorized
    assert_select ".alert", /Invalid code/
    assert_nil session[:user_id]
  end

  test "destroy signs out" do
    sign_in_as(User.create!(email: "bye@example.com"))

    delete session_path
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end

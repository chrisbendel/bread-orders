require "test_helper"

class MagicLinkAuthTest < ActionDispatch::IntegrationTest
  test "user requests magic link and signs in" do
    ActionMailer::Base.deliveries.clear

    # Visit sign in page
    get new_session_path
    assert_response :success

    # Request magic link
    post session_path, params: {email: "person@example.com"}
    assert_redirected_to new_session_path

    # Email was sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = ActionMailer::Base.deliveries.first
    assert_equal ["person@example.com"], mail.to

    # Extract the magic link URL from the email body
    body = mail.html_part&.body&.to_s || mail.body.to_s
    url = body[/href="(http[^"]+)"/, 1] || body[/\bhttp[^\s<]+/]
    assert url.present?, "Expected magic link URL in email body"

    # Follow magic link
    get url
    assert_redirected_to dashboard_path

    follow_redirect!
    assert_response :success
    assert_match(/Welcome/, @response.body)

    # Sign out
    delete session_path
    assert_redirected_to root_path
  end
end

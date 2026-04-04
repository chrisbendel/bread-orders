require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActiveJob::Base.queue_adapter = :test
  end

  test "GET new renders contact form" do
    get new_contact_path
    assert_response :success
    assert_select "form"
    assert_select "textarea[name='message']"
  end

  test "POST create with valid message enqueues email and redirects" do
    assert_enqueued_emails 1 do
      post contact_path, params: {
        name: "Alice",
        email: "alice@example.com",
        message: "Love the app!"
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_select ".notice", /thanks for reaching out/i
  end

  test "POST create without message re-renders form with alert" do
    assert_no_enqueued_emails do
      post contact_path, params: {name: "Alice", email: "alice@example.com", message: ""}
    end

    assert_response :unprocessable_entity
    assert_select ".alert", /can't be blank/i
  end

  test "POST create works without name or email" do
    assert_enqueued_emails 1 do
      post contact_path, params: {message: "Anonymous feedback here."}
    end

    assert_redirected_to root_path
  end
end

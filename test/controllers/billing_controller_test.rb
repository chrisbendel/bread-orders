require "test_helper"

class BillingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "baker@example.com")
  end

  test "GET upgrade requires authentication" do
    get billing_upgrade_path
    assert_redirected_to new_session_path
  end

  test "GET upgrade renders for free user" do
    sign_in_as(@user)
    get billing_upgrade_path
    assert_response :success
  end

  test "GET upgrade renders for pro user" do
    @user.update!(plan: :pro)
    sign_in_as(@user)
    get billing_upgrade_path
    assert_response :success
  end
end

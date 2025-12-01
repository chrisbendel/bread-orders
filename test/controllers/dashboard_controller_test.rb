require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test@example.com")
  end

  test "redirects when not authenticated" do
    get dashboard_path
    assert_redirected_to root_path
  end

  test "renders dashboard when signed in" do
    sign_in_as(@user) # helper in test_helper.rb
    get dashboard_path
    assert_response :success
    assert_select "h1", /Dashboard/
  end
end

require "test_helper"

class Stores::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test@example.com")
    @store = Store.create!(user: @user, name: "Test Store", slug: "test-store")

    @event = @store.events.create!(
      name: "Bread Pickup",
      description: "Fresh sourdough",
      orders_open_at: 1.day.ago,
      orders_close_at: 1.day.from_now,
      pickup_at: 2.days.from_now
    )

    # Sign in so authenticated routes work in integration tests
    sign_in_as(@user)
  end

  test "GET index shows events" do
    get store_events_path
    assert_response :success
    assert_select "h1", /Events/i
  end

  test "GET show displays the event" do
    get store_event_path(@event)
    assert_response :success
    assert_select "h2", @event.name
  end

  test "GET new renders form" do
    get new_store_event_path
    assert_response :success
    assert_select "form"
  end

  test "POST create creates an event and redirects" do
    assert_difference "@store.events.count", 1 do
      post store_events_path, params: {
        event: {
          name: "Market Day",
          description: "Outdoor bread pickup",
          orders_open_at: Time.current,
          orders_close_at: 2.days.from_now,
          pickup_at: 3.days.from_now
        }
      }
    end

    new_event = @store.events.order(:created_at).last
    assert_redirected_to store_event_path(new_event)
    follow_redirect!
    assert_select ".notice", /Event created/i
  end

  test "POST create with invalid params renders new with 422" do
    assert_no_difference "@store.events.count" do
      post store_events_path, params: {event: {name: ""}}
    end
    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "GET edit renders form" do
    get edit_store_event_path(@event)
    assert_response :success
    assert_select "form"
  end

  test "PATCH update updates event and redirects" do
    patch store_event_path(@event), params: {
      event: {name: "Updated Name"}
    }

    assert_redirected_to store_event_path(@event)
    @event.reload
    assert_equal "Updated Name", @event.name
  end

  test "PATCH update with invalid data renders edit with 422" do
    patch store_event_path(@event), params: {
      event: {name: ""}
    }

    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "DELETE destroy removes event and redirects" do
    assert_difference "@store.events.count", -1 do
      delete store_event_path(@event)
    end

    assert_redirected_to store_events_path
    follow_redirect!
    assert_select ".notice", /deleted/i
  end
end

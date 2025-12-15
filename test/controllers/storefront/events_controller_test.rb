require "test_helper"

module Storefront
  class EventsControllerTest < ActionDispatch::IntegrationTest
    def setup
      @owner = User.create!(email: "owner-#{SecureRandom.hex(4)}@example.com")
      @store = Store.create!(name: "Test Store", slug: "test-store-#{SecureRandom.hex(4)}", user: @owner)
      @event = @store.events.create!(name: "Test Event", orders_close_at: 1.day.from_now, pickup_at: 2.days.from_now)
      @event_product = @event.event_products.create!(name: "Sourdough", price: 10, quantity: 100)
      @event.publish!
    end

    test "should get show for published event" do
      get storefront_event_url(@store.slug, @event)
      assert_response :success
    end

    test "should give 404 for unknown store" do
      get storefront_event_url("unknown-store", @event)
      assert_response :not_found
    end

    test "should give 404 for unknown event" do
      get storefront_event_url(@store.slug, "999999")
      assert_response :not_found
    end

    test "should give 404 for draft event" do
      draft_event = @store.events.create!(name: "Draft Event", orders_close_at: 1.day.from_now, pickup_at: 2.days.from_now)
      # Create product so it can be published (though we don't publish it, validation might require it if we tried to publish, but here we just need it created)
      draft_event.event_products.create!(name: "Item", price: 10, quantity: 10)

      get storefront_event_url(@store.slug, draft_event)
      assert_response :not_found
    end
  end
end

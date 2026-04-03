require "test_helper"

class Storefront::OrdersIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @baker = User.create!(email: "baker-#{SecureRandom.hex}@example.com")
    @store = Store.create!(name: "Test Bakery", slug: "test-bakery-#{SecureRandom.hex}", user: @baker, address: "123 Main St")
    @event = @store.events.create!(
      name: "Big Bake",
      orders_close_at: 1.day.from_now,
      pickup_at: 2.days.from_now
    )
    @product = @event.event_products.create!(name: "Sourdough", quantity: 10, price_cents: 1000)
    @event.publish!

    @customer = User.create!(email: "customer-#{SecureRandom.hex}@example.com")
    sign_in_as(@customer)
    ActionMailer::Base.deliveries.clear
  end

  test "confirming an order" do
    # 1. Add item
    post storefront_event_order_items_path(@store.slug, @event), params: { event_product_id: @product.id }
    @order = @event.orders.find_by(user: @customer)
    assert_not @order.confirmed?

    # 2. Confirm
    post confirm_storefront_event_path(@store.slug, @event)
    assert_redirected_to storefront_event_path(@store.slug, @event)
    
    @order.reload
    assert @order.confirmed?
    assert_equal 1, ActionMailer::Base.deliveries.count
  end

  test "unconfirming an order" do
    @order = Order.create!(user: @customer, event: @event, confirmed_at: Time.current)
    
    post unconfirm_storefront_event_path(@store.slug, @event)
    assert_redirected_to storefront_event_path(@store.slug, @event)
    
    @order.reload
    assert_not @order.confirmed?
  end

  test "downloading ics file" do
    get calendar_storefront_event_path(@store.slug, @event)
    
    assert_response :success
    assert_equal "text/calendar", response.content_type
    assert_match(/big-bake-pickup.ics/, response.headers["Content-Disposition"])
    assert_match(/BEGIN:VCALENDAR/, response.body)
    assert_match(/SUMMARY:Order Pickup: Big Bake — Test Bakery/, response.body)
  end
end

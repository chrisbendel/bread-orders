require "application_system_test_case"

class OrderConfirmationTest < ApplicationSystemTestCase
  setup do
    @baker = User.create!(email: "baker@example.com")
    @store = Store.create!(name: "Test Bakery", slug: "test-bakery", user: @baker, address: "123 Main St")
    @event = @store.events.create!(
      name: "Big Bake",
      orders_close_at: 1.day.from_now,
      pickup_at: 2.days.from_now
    )
    @product = @event.event_products.create!(name: "Sourdough", quantity: 10, price_cents: 1000)
    @event.publish!

    @customer = User.create!(email: "customer@example.com")
  end

  test "full order confirmation flow" do
    sign_in_via_browser(@customer)
    visit storefront_event_path(@store.slug, @event)

    # 1. Add item
    within ".card", text: "Sourdough" do
      click_on "Add to Order"
    end

    assert_text "Added Sourdough"
    assert_button "Complete Order"

    # 2. Confirm order
    click_on "Complete Order"

    assert_text "Order confirmed!"
    assert_selector "aside", text: "Order confirmed"
    assert_link "Add to Google Calendar"
    assert_link "Download .ics"

    # 3. Add another item (should unconfirm)
    within ".card", text: "Sourdough" do
      click_on "Add to Order"
    end

    assert_text "Added Sourdough"
    assert_selector "aside", text: "Your order"
    assert_button "Complete Order"

    # 4. Confirm again
    click_on "Complete Order"
    assert_text "Order confirmed!"

    # 5. Edit Order button should unconfirm
    click_on "Edit Order"
    assert_button "Complete Order"

    # 6. Remove item (should now be visible)
    accept_confirm do
      within "aside" do
        find("button[aria-label='Remove Sourdough']").click
      end
    end

    assert_text "Removed Sourdough"
    assert_button "Complete Order"
  end

  test "downloading ics file" do
    sign_in_via_browser(@customer)
    visit storefront_event_path(@store.slug, @event)

    within find(".card", text: "Sourdough") do
      click_on "Add to Order"
    end
    click_on "Complete Order"

    click_on "Download .ics"

    # Basic content verification (response_headers not supported in system tests)
    assert_match(/BEGIN:VCALENDAR/, page.body)
  end
end

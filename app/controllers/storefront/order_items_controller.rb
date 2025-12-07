module Storefront
  class OrderItemsController < ApplicationController
    before_action :require_authentication!
    before_action :set_store
    before_action :set_event
    before_action :set_product

    def create
      order = Order.find_or_create_by!(user: current_user, event: @event)

      item = order.order_items.find_or_initialize_by(event_product: @product)
      if item.new_record?
        item.quantity = 1
        item.unit_price_cents = @product.price_cents
      else
        item.quantity += 1
      end

      item.save!

      redirect_to storefront_event_path(@store.slug, @event), notice: "Added!"
    end

    private

    def set_store
      @store = Store.find_by!(slug: params[:slug])
    end

    def set_event
      @event = @store.events.find(params[:event_id])
    end

    def set_product
      @product = @event.event_products.find(params[:event_product_id])
    end
  end
end

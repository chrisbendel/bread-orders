module Storefront
  class OrderItemsController < ApplicationController
    before_action :require_authentication!
    before_action :set_store, only: [:create]
    before_action :set_event, only: [:create]
    before_action :set_product, only: [:create]

    def create
      return if @event.draft?
      order = Order.find_or_create_by!(user: current_user, event: @event)

      item = order.order_items.find_or_initialize_by(event_product: @product)

      if @product.remaining < 1
        redirect_to storefront_event_path(@store.slug, @event), alert: "Sorry, that item is out of stock!"
        return
      end

      if item.new_record?
        item.quantity = 1
        item.unit_price_cents = @product.price_cents
      else
        item.quantity += 1
      end

      item.save!

      redirect_to storefront_event_path(@store.slug, @event), notice: "Added!"
    end

    def update
      # For shallow routes, we look up the item directly, then derive context
      item = current_user.order_items.find(params[:id])
      @event = item.order.event
      @store = @event.store

      new_quantity = params.dig(:order_item, :quantity).to_i

      if new_quantity > 0
        # Check stock if increasing
        if new_quantity > item.quantity
          required = new_quantity - item.quantity
          if required > item.event_product.remaining
            redirect_to storefront_event_path(@store.slug, @event), alert: "Sorry, we don't have enough stock for that quantity."
            return
          end
        end

        item.update!(quantity: new_quantity)
        notice = "Updated quantity."
      else
        item.destroy!
        notice = "Removed item."
      end

      redirect_to storefront_event_path(@store.slug, @event), notice: notice
    end

    def destroy
      item = current_user.order_items.find(params[:id])
      @event = item.order.event
      @store = @event.store
      
      item.destroy!

      redirect_to storefront_event_path(@store.slug, @event), notice: "Removed item."
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

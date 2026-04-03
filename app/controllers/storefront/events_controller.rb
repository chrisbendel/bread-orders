module Storefront
  class EventsController < ApplicationController
    before_action :set_store
    before_action :set_event

    include CalendarHelper

    def show
      @products = @event.event_products
      @order = @event.orders.find_by(user: current_user)
    end

    def calendar
      send_data ics_export(@event),
        filename: "#{@event.name.parameterize}-pickup.ics",
        type: "text/calendar",
        disposition: "attachment"
    end

    private

    def set_store
      @store = Store.find_by!(slug: params[:slug])
    end

    def set_event
      @event = @store.events.published.find(params[:id])
    end
  end
end

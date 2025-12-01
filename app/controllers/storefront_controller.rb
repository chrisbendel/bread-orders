class StorefrontController < ApplicationController
  def show
    @store = Store.find_by!(slug: params[:slug])
    @events = @store.events.active
    @notification = if authenticated?
      current_user.store_notifications.find_by(store: @store)
    end
  end
end

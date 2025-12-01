class StorefrontController < ApplicationController
  def show
    @store = Store.find_by!(slug: params[:slug])
    @events = @store.events.active
    @subscription = if authenticated?
      current_user.store_subscriptions.find_by(store: @store)
    end
  end
end

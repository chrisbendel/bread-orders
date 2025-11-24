class StorefrontController < ApplicationController
  def show
    @store = Store.find_by!(slug: params[:slug])
    # TODO Wire in orders when we have them
    # @orders = @store.orders.open
  end
end

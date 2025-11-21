class StorefrontController < ApplicationController
  def show
    @store = Store.find_by!(slug: params[:slug])
    @orders = @store.orders.open
  end
end

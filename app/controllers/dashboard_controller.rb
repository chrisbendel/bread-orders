class DashboardController < ApplicationController
  before_action :require_authentication!

  def index
    @user = current_user
    redirect_to store_path and return if @user.store
    @orders = current_user.orders.includes(:order_items, event: :store).order(created_at: :desc)
  end
end

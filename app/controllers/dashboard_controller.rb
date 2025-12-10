class DashboardController < ApplicationController
  before_action :require_authentication!

  def index
    @user = current_user
    @orders = current_user.orders.includes(event: :store).order(created_at: :desc)
  end
end

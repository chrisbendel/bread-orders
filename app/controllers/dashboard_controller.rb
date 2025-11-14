class DashboardController < ApplicationController
  before_action :require_authentication!

  def index
    @user = current_user
    # Placeholder for future: show upcoming orders the owner created
  end
end

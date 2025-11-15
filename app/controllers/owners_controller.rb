class OwnersController < ApplicationController
  def show
    @owner = User.find_by!(username: params[:username])
    # Placeholder: list upcoming orders for @owner
  end
end

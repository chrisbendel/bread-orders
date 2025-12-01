class PublicUnsubscribesController < ApplicationController
  skip_before_action :require_authentication!

  def unsubscribe
    subscription = StoreSubscription.find_by(unsubscribe_token: params[:token])

    if subscription
      subscription.destroy
      render :success
    else
      render :not_found, status: :not_found
    end
  end
end

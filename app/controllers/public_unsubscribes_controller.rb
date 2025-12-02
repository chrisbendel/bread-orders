class PublicUnsubscribesController < ApplicationController
  def unsubscribe
    notification = StoreNotification.find_by(unsubscribe_token: params[:token])

    if notification
      notification.destroy
      render :success
    else
      render :not_found, status: :not_found
    end
  end
end

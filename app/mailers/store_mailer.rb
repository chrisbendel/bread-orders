class StoreMailer < ApplicationMailer
  def new_event(store, event, notification)
    @store = store
    @event = event
    @unsubscribe_url = unsubscribe_url(token: notification.unsubscribe_token)

    mail(
      to: notification.user.email,
      subject: "#{store.name} has a new event available"
    )
  end
end

class OrderMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.confirmation_email.subject
  #
  def confirmation_email
    @order = params[:order]
    @event = @order.event
    @store = @event.store

    mail(
      to: @order.user.email,
      subject: "Order confirmed: #{@event.name} — #{@store.name}"
    )
  end
end

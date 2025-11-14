class SessionMailer < ApplicationMailer
  default from: "no-reply@orders.example"

  def magic_link
    @user = params[:user]
    token = @user.signed_id(purpose: :magic_login, expires_in: 30.minutes)
    @url = magic_link_url(token: token)
    mail to: @user.email, subject: "Your sign-in link"
  end
end

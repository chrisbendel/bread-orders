class SessionMailer < ApplicationMailer
  default from: "bread@bread-orders.fly.dev"

  def login_code(user, plain_code)
    @user = user
    @code = plain_code
    mail to: user.email, subject: "Your login code"
  end
end

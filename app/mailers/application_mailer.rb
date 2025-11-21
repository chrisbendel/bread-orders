class ApplicationMailer < ActionMailer::Base
  default from: "bread@bread-orders.fly.dev"
  layout "mailer"
end

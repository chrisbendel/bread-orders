class ContactMailer < ApplicationMailer
  FEEDBACK_ADDRESS = "chrissbendel@gmail.com"

  def feedback(name:, email:, message:)
    @name = name.presence || "Anonymous"
    @email = email
    @message = message

    mail(
      to: FEEDBACK_ADDRESS,
      reply_to: email.present? ? email : FEEDBACK_ADDRESS,
      subject: "LocalBaker feedback#{" from #{@name}" if name.present?}"
    )
  end
end

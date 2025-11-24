if Rails.application.credentials.RESEND_API_KEY
  Resend.api_key = Rails.application.credentials.RESEND_API_KEY
end

class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:email].to_s.strip.downcase
    if email.blank?
      redirect_to new_session_path, alert: "Please enter your email." and return
    end

    user = User.find_or_initialize_by(email: email)
    user.save! if user.new_record?

    SessionMailer.with(user: user).magic_link.deliver_later

    redirect_to new_session_path, notice: "Check your email for a sign-in link."
  end

  # Magic link endpoint: /auth?token=...
  def show
    token = params[:token].to_s
    user = User.find_signed(token, purpose: :magic_login)
    if user
      sign_in user
      redirect_to dashboard_path, notice: "Signed in successfully."
    else
      redirect_to new_session_path, alert: "That link is invalid or has expired."
    end
  end

  def destroy
    sign_out
    redirect_to root_path, notice: "Signed out."
  end
end

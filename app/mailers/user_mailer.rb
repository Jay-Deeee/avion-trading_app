class UserMailer < ApplicationMailer
  default from: 'no-reply@aviontradingapp.com'

  def pending_approval(user)
    @user = user
    mail(to: @user.email, subject: "Your registration is pending admin approval")
  end
end

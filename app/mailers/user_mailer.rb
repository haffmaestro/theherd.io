class UserMailer < ActionMailer::Base
  default from: "halfdan@theherd.io"

  def welcome_email(user)
    @user = user
    @url  = "www.theherd.io"
    mail(to: @user.email, subject: 'Welcome to theHerd')
  end
end

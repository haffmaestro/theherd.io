class FeedbackMailer < ActionMailer::Base

  def feedback_email(user, feedback)
    @user = user
    @feedback = feedback
    @url  = "www.theherd.io"
    mail(to: "halfdanhem@gmail.com", subject: "[theHerdFeedback]", from: user[:email])
  end
end
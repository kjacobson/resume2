class UserMailer < ActionMailer::Base
  default :from => "mailer@re-cv.com"

  def login_email(user, validation)
    @user = user
    @validation = validation
    return if @validation.user_id != @user.id
    mail(:to => @user.email, :subject => "Your re-cv.com login link")
  end
end

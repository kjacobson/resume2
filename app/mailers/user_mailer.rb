class UserMailer < ActionMailer::Base
  require 'mail'
  #default :from => "mailer@re-cv.com"

  def from_address
    address = Mail::Address.new "mailer@re-cv.com"
    address.display_name = "Re-CV.com"
    address.format
  end

  def login_email(user, validation)
    @user = user
    @validation = validation
    return if @validation.user_id != @user.id
    mail(:from => from_address, :to => @user.email, :subject => "Your re-cv.com login link")
  end
end

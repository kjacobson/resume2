# app/models/user_session.rb
class UserSession < Authlogic::Session::Base
  # configuration here, see documentation for sub modules of Authlogic::Session
  remember_me_for 6.months
end
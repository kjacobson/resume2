class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user
  before_filter :require_user_match, :only => [:new, :create, :edit, :update]

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
  
    def require_known_user
      unless current_user
         redirect_to :homepage, :notice => 'You must be an admin to access the requested resource.'
         return false
      end
    end

    def require_user_match
      unless current_user.id === params[:user_id]
        redirect_to :homepage, :notice => "You can't see that"
        return false
      end
    end

    def is_user_match?
      current_user.id === params[:user_id]
    end

    def set_user_match_var
      if is_user_match?
        @user_match = true
      end
    end
end
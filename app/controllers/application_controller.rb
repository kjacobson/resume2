class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user
  before_filter :require_user_match, :except => [:signup, :login, :logout, :index, :show]

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
         redirect_to :homepage, :notice => 'You must be an logged in to access the requested resource.'
         return false
      end
    end

    def require_user_match
      controller = params[:controller]
      action = params[:action]
      return if ["user_sessions","users"].include?(controller) and ["new","create"].include?(action)
      unless current_user.id === params[:user_id].to_i
        flash[:notice] = "You can't access this page, as it belongs to a different user. You: #{current_user.id}."
        return false
      end
    end

    def is_user_match?
      current_user.id === params[:user_id]
    end

    def set_user_match_var
        @user_match = is_user_match?
    end
end
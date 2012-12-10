class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user
  before_filter :require_resource_match
  before_filter :set_basic_instance_vars
  before_filter :require_user_match, :except => [:signup, :login, :logout, :index, :show]

  def verify_rights
    ok = true
    if not is_admin?
      if params[:user_id].nil?
        ok = false
      elsif params[:resume_id].nil?
        require_user_match
      end
    end
    if not ok
      flash[:notice] = "You are not authorized to access this page"
      redirect_to :homepage
    end
    ok
  end

  def set_basic_instance_vars
    if user_id = params[:user_id] or (params[:controller] == "users" and user_id = params[:id])
      if not @user = User.find(user_id)
        flash[:notice] = "The user whose information you&rsquo;re trying to view doesn&rsquo;t seem to exist."
        # TODO: this should be a 404
        redirect_to :homepage
      end
    end
    if resume_id = params[:resume_id] or (params[:controller] == "resumes" and resume_id = params[:id])
      if not @resume = Resume.find(resume_id)
        flash[:notice] = "The resume you&rsquo;re trying to view doesn&rsquo;t seem to exist."
        # TODO: this should be a 404
        redirect_to :homepage
      end
    end
  end

  def require_known_user
    unless current_user
      flash[:notice] = "You must be an logged in to access the requested resource."
      redirect_to :homepage
      return false
    end
  end

  def require_user_match
    require_known_user
    controller = params[:controller]
    action = params[:action]
    return if ["user_sessions","users"].include?(controller) and ["new","create"].include?(action)
    unless is_user_match?
      flash[:notice] = "You can't access this page, as it belongs to a different user."
      redirect_to :homepage
    end
  end

  def require_admin_user
    return false
  end

  helper_method :is_admin_user?
  def is_admin_user?
    return false
  end

  helper_method :is_user_match?
  def is_user_match?
    if !params[:user_id].nil?
      page_user_id = params[:user_id].to_i
    elsif params[:controller] == "users" and !params[:id].nil?
      page_user_id = params[:id].to_i
    else
      page_user_id = nil
    end
    !current_user.nil? ? current_user.id === page_user_id : false
  end

  MODELS = ["users","resumes","jobs","skills","softwares","highlights","disciplines","links","years","job_skills","job_software","resume_highlight","resume_job","user_skill","user_software"]
  ACTIONS = ["index","show","new","edit","create","update","destroy"]
  # TODO: this REALLY needs a test
  def require_resource_match
    path = request.path[1..-1]
    vars = path.split("/")
    return unless vars[0] == "users"
    query = User.find_by_id(vars[1])
    vars[2..-1].each_with_index do |var, i|
      break if query.nil?
      break if var == "years"
      break if ACTIONS.include?(var)
      if i % 2 == 0
        query = MODELS.include?(var) ? query.send(var) : nil
      elsif /\A[0-9]+\Z/.match(var)
        query = query.find_by_id(var)
      elsif ["skills","softwares"].include?(vars[i-1])
        query = query.find_by_slug(var)
      end
    end
    unless !query.nil?
      flash[:notice] = "404"
      redirect_to :homepage
    end
  end

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
end
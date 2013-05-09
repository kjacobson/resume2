class ApplicationController < ActionController::Base
  protect_from_forgery :secret => "g273o382g495e504o162d456u094c897k112s344g613o"

  helper_method :current_user_session, :current_user
  before_filter :require_resource_match
  before_filter :set_basic_instance_vars
  before_filter :require_user_match, :except => [:signup, :login, :logout, :index, :show, :disclaimer]
  before_filter :require_access_key, :only => [:index, :show]
  require 'digest/md5'

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

  def has_access_key?
    set_basic_instance_vars unless @user
    if @resume and @resume.links.size > 0
      if key = params[:access_key]
        @link = Link.find_by_unique_key(key)
        session[:access_key] = key
      else
        key = session[:access_key]
      end
      if key and @link = Link.find_by_unique_key(key)
        return true if @resume.links.include?(@link) and !@link.expired?
      end
    end
    return false
  end

  def require_known_user
    unless current_user
      flash[:notice] = "You must be logged in to access the requested resource."
      redirect_to :homepage
      return false
    end
  end

  def require_access_key
    unless has_access_key? or is_user_match? or preview_mode?
      flash[:notice] = "To access the requested page, you must have been given a link by the resume&rsquo;s author."
      redirect_to "/"
    end
  end

  def require_user_match
    require_known_user
    unless is_user_match? or preview_mode?
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
    return @user_match unless @user_match.nil?
    return @user_match = false if current_user.nil?
    if !params[:user_id].nil?
      page_user_id = params[:user_id].to_i
    elsif params[:controller] == "users" and !params[:id].nil?
      page_user_id = params[:id].to_i
    else
      page_user_id = nil
    end
    @user_match = current_user.try(:id) == page_user_id && !preview_mode?
  end

  helper_method :preview_mode?
  def preview_mode?
    return @preview_mode unless @preview_mode.nil?
    @preview_mode = !@resume.nil? && (session[:preview_resume] == @resume.id.to_s)
  end

  MODELS = ["users","resumes","jobs","skills","softwares","highlights","disciplines","links","years","job_skills","job_software","resume_highlight","resume_job","user_skill","user_software"]
  ACTIONS = ["index","show","new","edit","create","update","destroy","confirm_delete","preview"]
  # TODO: this REALLY needs a test
  def require_resource_match
    path = request.path[1..-1]
    vars = path.split("/")
    return unless vars[0] == "users"
    query = vars.count > 1 ? User.find_by_id(vars[1]) : vars[0]
    if vars.count > 2
      vars[2..-1].each_with_index do |var, i|
        break if query.nil?
        break if var == "years"
        break if ACTIONS.include?(var)
        if i % 2 == 0
          query = MODELS.include?(var) ? query.send(var) : nil
        elsif /\A[0-9]+\Z/.match(var)
          query = query.find_by_id(var) rescue query = query.select { |item| item.id == var.to_i }[0]
        elsif ["skills","softwares"].include?(vars[i+1]) # we started at vars[2], with i = 0
          query = query.find_by_slug(var) rescue query = query.select { |item| item.slug == var }[0]
        end
      end
    end
    if query.nil?
      flash[:notice] = "401"
      redirect_to :homepage
    end
  end

  def breadcrumbs(k, v)
    @breadcrumbs = Hash.new() if @breadcrumbs.nil?
    @breadcrumbs[k] = v
    return @breadcrumbs
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
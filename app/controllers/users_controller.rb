class UsersController < ApplicationController
  skip_before_filter :require_user_match, [:new, :create]

  def save_disciplines(disciplines, user)
    disciplines.each do |di|
      di = di.strip()
      disc = Discipline.new({:title => di, :user_id => user.id})
      if disc.save
        logger.debug "Saved a discpline: #{di}"
      end
    end
  end

  def index
    @users = User.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @jobs }
    end
  end

  def new
    @user = User.new
    @resume = Resume.new
  end

  def create
    @user_session = UserSession.find
    if !@user_session.nil?
      @user_session.destroy
    end
    @user = User.new(params[:user])
    @resume = @user.resumes.build(params[:resume])
    @disciplines = params[:disciplines]
    @disciplines.keep_if {|d| d.strip() != ""}
    if @user.save
      if @resume.save
        save_disciplines(@disciplines, @user)

        flash[:notice] = "So far, so good. Now enter a job to start filling your resume."
        redirect_to new_job_path(@user, :resume_id => @resume.id)
      else
        flash[:notice] = "Your account has been set up, but there was an error creating your first blank resume."
        redirect_to user_path(@user)
      end
    else
      render :action => :new
    end
  end

  def show
    @user = User.find(params[:id])
    @resumes = @user.resumes.order("created_at DESC")
    @disciplines = @user.disciplines
    @skills = @user.skills.order("rank DESC")
    @softwares = @user.softwares.order("rank DESC")
    # TODO: still need to sort by end_month, but with 0 as a special case
    @jobs = @user.jobs.order("end_year DESC")
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to user_path(@user)
    else
      render :action => :edit
    end
  end
end
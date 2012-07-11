class ResumesController < ApplicationController
  before_filter :set_instance_vars, :only => [:show, :edit, :update]

  def set_instance_vars
    @resume = Resume.find(params[:id])
    @user = @resume.user
    @jobs = @user.jobs.order("end_year DESC")
    @skills = @resume.skills.sort { |a,b| a.title <=> b.title }
    @softwares = @resume.softwares.sort { |a,b| b.rank <=> a.rank }
  end

  # GET /resumes
  # GET /resumes.xml
  def index
    @resumes = Resume.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resumes }
    end
  end

  # GET /resumes/1
  # GET /resumes/1.xml
  def show
    @jobs = @jobs[0..6]
    @disciplines = Discipline.find_all_by_user_id(@user.id)
    @softwares = @softwares[0..4]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resume }
    end
  end

  # GET /resumes/new
  # GET /resumes/new.xml
  def new
    @resume = Resume.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resume }
    end
  end

  # GET /resumes/1/edit
  def edit
    @user_jobs = @user.jobs
  end

  # POST /resumes
  # POST /resumes.xml
  def create
    @resume = Resume.new(params[:resume])

    respond_to do |format|
      if @resume.save
        format.html { redirect_to(@resume, :notice => 'Resume was successfully created.') }
        format.xml  { render :xml => @resume, :status => :created, :location => @resume }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resume.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resumes/1
  # PUT /resumes/1.xml
  def update
    respond_to do |format|
      if @resume.update_attributes(params[:resume])
        format.html { redirect_to(@resume, :notice => 'Resume was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resume.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resumes/1
  # DELETE /resumes/1.xml
  def destroy
    @resume = Resume.find(params[:id])
    @resume.destroy

    respond_to do |format|
      format.html { redirect_to(resumes_url) }
      format.xml  { head :ok }
    end
  end
end

class JobsController < ApplicationController
  before_filter :require_known_user, :only => [:new, :create, :edit, :update, :destroy]
  
  # GET /jobs
  # GET /jobs.json
  def index
    @order_by = !params[:order_by].nil? ? params[:order_by] : "end_year"
    @direction = !params[:direction].nil? ? params[:direction] : "DESC"
    if @order_by == "end_year"
      @secondary_sort = ", end_month " + @direction
    else
      @secondary_sort = ""
    end
    
    if !params[:skill_id].nil?
        @skill = Skill.find_by_id(params[:skill_id])
        @jobs = @skill.jobs.order(@order_by + " " + @direction)
    elsif !params[:software_id].nil?
        @software = Software.find_by_id(params[:software_id])
        @jobs = @software.jobs.order(@order_by + " " + @direction)
    elsif !params[:year_id].nil?
        @year = Year.find_by_value(params[:year_id])
        @jobs = @year.jobs.order(@order_by + " " + @direction)
    else
        @jobs = Job.find(:all, :order => @order_by + " " + @direction + @secondary_sort)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])
    @skills = @job.skills.order("rank DESC")
    @softwares = @job.softwares.order("title ASC")
    @years = @job.years.sort! { |a,b| a <=> b }
    @highlights = @job.highlights.order("skill_id")
    @disciplines = @job.disciplines

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    @job = Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
    @skills = Job.skills
    @softwares = Job.softwares
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(params[:job])
    @job.user_id = current_user.id


    respond_to do |format|
      if @job.save
        format.html { redirect_to(new_job_skill_path(@job.id), :notice => 'Job was successfully created. Now enter the skills you used.') }
        format.json  { render :json => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.json
  def update
    @job = Job.find(params[:id])
    @skills = params[:job][:skills]
    if !@skills.nil? && @skills != ""
      @skills.split(",").each do |s|
        sk = Skill.find_by_title(s)
        if !sk
          sk = Skill.new({:title => s, :slug => s})
          sk.save
        end
        js = JobSkill.new({:job_id => @job.id, :skill_id => sk.id})
        js.save
      end
    end                         
    @softwares = params[:job][:softwares]
    if !@softwares.nil? && @softwares != ""
      @softwares.split(",").each do |s|
        so = Software.find_by_title(s)
        if !so
          so = Software.new({:title => s, :slug => s})
          so.save
        end
        js = JobSoftware.new({:job_id => @job.id, :software_id => so.id})
        js.save
      end
    end

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to(@job, :notice => 'Job was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.json  { head :ok }
    end
  end
end

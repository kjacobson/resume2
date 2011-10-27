class ResumeJobsController < ApplicationController
  # GET /resume_jobs
  # GET /resume_jobs.xml
  def index
    @resume_jobs = ResumeJob.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resume_jobs }
    end
  end

  # GET /resume_jobs/1
  # GET /resume_jobs/1.xml
  def show
    @resume_job = ResumeJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resume_job }
    end
  end

  # GET /resume_jobs/new
  # GET /resume_jobs/new.xml
  def new
    @resume_job = ResumeJob.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resume_job }
    end
  end

  # GET /resume_jobs/1/edit
  def edit
    @resume_job = ResumeJob.find(params[:id])
  end

  # POST /resume_jobs
  # POST /resume_jobs.xml
  def create
    @resume_job = ResumeJob.new(params[:resume_job])

    respond_to do |format|
      if @resume_job.save
        format.html { redirect_to(@resume_job, :notice => 'Resume job was successfully created.') }
        format.xml  { render :xml => @resume_job, :status => :created, :location => @resume_job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resume_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resume_jobs/1
  # PUT /resume_jobs/1.xml
  def update
    @resume_job = ResumeJob.find(params[:id])

    respond_to do |format|
      if @resume_job.update_attributes(params[:resume_job])
        format.html { redirect_to(@resume_job, :notice => 'Resume job was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resume_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resume_jobs/1
  # DELETE /resume_jobs/1.xml
  def destroy
    @resume_job = ResumeJob.find(params[:id])
    @resume_job.destroy

    respond_to do |format|
      format.html { redirect_to(resume_jobs_url) }
      format.xml  { head :ok }
    end
  end
end

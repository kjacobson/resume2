class ResumesController < ApplicationController
  before_filter :set_instance_vars, :only => [:show, :edit, :update]

  def set_instance_vars
    # TODO: still need a secondary sort on end_month, but with 0 as special case
    @jobs = @resume.jobs.order("end_year DESC")
    @skills = @resume.skills.sort { |a,b| a.rank <=> b.rank }
    @softwares = @resume.softwares.sort { |a,b| b.rank <=> a.rank }
    @disciplines = @resume.disciplines
  end

  def save_resume_jobs(resume_id, job_ids)
    job_ids.each do |j|
      j = j.to_i
      if ResumeJob.where({:resume_id => resume_id, :job_id => j}) == []
        save_resume_job(resume_id, j)
      end
    end
  end

  def save_resume_job(resume_id, job_id)
    rj = ResumeJob.new({:resume_id => resume_id, :job_id => job_id})
    if rj.save
      logger.debug "Saved a resume job"
    else
      logger.debug "Failed to save a resume job"
    end
  end

  def delete_resume_jobs(resume_id, job_ids)
    job_ids.each do |j|
      j = j.to_i
      rjs = ResumeJob.where({:resume_id => resume_id, :job_id => j})
      unless rjs == []
        rjs.each do |rj|
          if rj.destroy
            logger.debug "Destroyed a resume job that's no longer needed.'"
          end
        end
      end
    end
  end

  # GET /resumes
  # GET /resumes.xml
  def index
    require_user_match

    @order_by = !params[:order_by].nil? ? params[:order_by] : "title"
    @direction = !params[:direction].nil? ? params[:direction] : "DESC"
    if @order_by == "created_at"
      @secondary_sort = ", title " + @direction
    else
      @secondary_sort = ""
    end
    @resumes = @user.resumes.order(@order_by + " " + @direction + @secondary_sort)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resumes }
    end
  end

  # GET /resumes/1
  # GET /resumes/1.xml
  def show
    @jobs = @jobs[0..6]
    @softwares = @softwares[0..4]
    @uncategorized_skills = @resume.uncategorized_skills
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resume }
    end
  end

  # GET /resumes/new
  # GET /resumes/new.xml
  def new
    @resume = Resume.new
    @user_jobs = @user.jobs
    @url = resumes_path({:user_id => @user.id})

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resume }
    end
  end

  # GET /resumes/1/edit
  def edit
    @user_jobs = @user.jobs
    @url = resume_path({:user_id => @user.id})
  end

  # POST /resumes
  # POST /resumes.xml
  def create
    @resume = Resume.new(params[:resume])

    respond_to do |format|
      if @resume.save
        if !params[:resume_jobs].nil?
          save_resume_jobs(@resume.id, params[:resume_jobs])
        end
        format.html { redirect_to(resume_path({:user_id => @user.id, :id => @resume.id}), :notice => 'Resume was successfully created.') }
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
        resume_jobs = params[:resume_jobs] || []
        rj_ids = @resume.resume_jobs.flat_map { |rj| rj.job_id.to_s }
        diff = rj_ids - resume_jobs
        if diff.count > 0
          delete_resume_jobs(@resume.id, diff)
        end
        if resume_jobs.size > 0
          save_resume_jobs(@resume.id, resume_jobs)
        end
        format.html { redirect_to(resume_path({:user_id => @user.id, :id => @resume.id}), :notice => 'Resume was successfully updated.') }
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
    @resume.destroy

    respond_to do |format|
      format.html { redirect_to(resumes_url) }
      format.xml  { head :ok }
    end
  end

  def confirm_delete
    @resume = Resume.find(params[:id])

    respond_to do |format|
      format.html { render :action => "confirm_delete" }
    end
  end

  def preview
    @resume = Resume.find(params[:id])
    if params[:preview] == "true"
      enter_preview_mode(@resume)
    else
      exit_preview_mode
    end
    redirect_to request.referer
  end

  def enter_preview_mode(resume)
    session[:preview_resume] = resume.id.to_s
    return true
  end

  def exit_preview_mode
    session.delete(:preview_resume)
    return true
  end
end

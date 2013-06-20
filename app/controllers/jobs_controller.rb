class JobsController < ApplicationController
  before_filter :require_known_user, :only => [:new, :create, :edit, :update, :destroy]

  def new_instance_vars
    @url = jobs_path({:user_id => current_user.id})
    @resumes = current_user.resumes
    @skills = []
    @softwares = []
    if !params[:resume_id].nil?
      @resume = Resume.find(params[:resume_id])
    end
  end

  def edit_instance_vars
    @url = job_path({:user_id => current_user.id})
    @skills = @job.skills
    @softwares = @job.softwares
    @resumes = current_user.resumes
    @j_resumes = @job.resumes
    if !params[:resume_id].nil?
      @resume = Resume.find(params[:resume_id])
    end
  end

  def save_resume_jobs(job_id, resume_ids)
    resume_ids.each do |rez|
      rez = rez.to_i
      if ResumeJob.where({:job_id => job_id, :resume_id => rez}) == []
        save_resume_job(job_id, rez)
      end
    end
  end

  def save_resume_job(job_id, resume_id)
    rj = ResumeJob.new({:job_id => job_id, :resume_id => resume_id})
    if rj.save
      logger.debug "Saved a resume_job"
      logger.debug rj.id
    end
  end

  def save_skills(skills, job, user)
    sk_ids = job.job_skills.flat_map { |js| js.skill_id }
    new_skill_ids = []
    skills.each do |sk|
      sk = sk.strip()
      do_job_skill = false
      skill = Skill.find_by_title(sk)
      if skill.nil?
        skill = Skill.new({:title => sk, :slug => sk.gsub(" ","-")})
        if skill.save
          do_job_skill = true
        end
      else
        new_skill_ids.push(skill.id)
        do_job_skill = true
      end
      if do_job_skill
        save_user_skill(skill, user)
        save_job_skill(skill, job, user)
      end
    end
    diff = sk_ids - new_skill_ids
    delete_job_skills(job.id, diff)
  end

  # TODO: this exists in SkillsController too. We should import that Class and use that method.
  def save_user_skill(skill, user)
    us = user.user_skills.find_by_skill_id(skill.id)
    if us.nil?
      us = UserSkill.new({:user_id => user.id, :skill_id => skill.id, :discipline_id => nil})
      if us.save
        logger.debug "Saved a user_skill!"
        logger.debug us.id
      else
        return false
      end
    end
  end

  def save_job_skill(skill, job, user)
    js = job.job_skills.find_by_skill_id(skill.id)
    if js.nil?
      js = JobSkill.new({:job_id => job.id, :skill_id => skill.id, :user_id => user.id})
      if js.save
        logger.debug "Saved a job skill!"
        logger.debug js.id
      else
        return false
      end
    end

    return true
  end

  def save_softwares(softwares, job, user)
    so_ids = job.job_softwares.flat_map { |js| js.software_id }
    new_software_ids = []
    softwares.each do |so|
      so = so.strip()
      do_job_software = false
      software = Software.find_by_title(so)
      if software.nil?
        software = Software.new({:title => so, :slug => so.gsub(" ","-")})
        if software.save
          do_job_software = true
        end
      else
        new_software_ids.push(software.id)
        do_job_software = true
      end
      if do_job_software
          save_user_software(software, user)
          save_job_software(software, job, user)
      end
    end
    diff = so_ids - new_software_ids
    delete_job_softwares(job.id, diff)
  end

  # TODO: this exists in SoftwaresController too. We should import that Class and use that method.
  def save_user_software(software, user)
    us = user.user_softwares.find_by_software_id(software.id)
    if us.nil?
      us = UserSoftware.new({:user_id => user.id, :software_id => software.id})
      if us.save
        logger.debug "Saved a user_software!"
        logger.debug us.id
      else
        return false
      end
    end
  end

  def save_job_software(software, job, user)
    js = job.job_softwares.find_by_software_id(software.id)
    if js.nil?
      js = JobSoftware.new({:job_id => @job.id, :software_id => software.id, :user_id => user.id})
      if js.save
        logger.debug "Saved a job software!"
        logger.debug js.id
      else
        return false
      end
    end

    return true
  end

  def delete_resume_jobs(job_id, resume_ids)
    resume_ids.each do |r|
      r = r.to_i
      rjs = ResumeJob.where({:resume_id => r, :job_id => job_id})
      unless rjs == []
        rjs.each do |rj|
          if rj.destroy
            logger.debug "Destroyed a resume job that's no longer needed."
          end
        end
      end
    end
  end

  def delete_job_skills(job_id, skill_ids)
    skill_ids.each do |sk|
      jsks = JobSkill.where({:skill_id => sk, :job_id => job_id})
      unless jsks == []
        jsks.each do |js|
          if js.destroy
            logger.debug "Destroyed a job skill that's no longer needed."
          end
        end
      end
    end
  end

  def delete_job_softwares(job_id, software_ids)
    software_ids.each do |so|
      jsos = JobSoftware.where({:software_id => so, :job_id => job_id})
      unless jsos == []
        jsos.each do |js|
          if js.destroy
            logger.debug "Destroyed a job software that's no longer needed."
          end
        end
      end
    end
  end
  
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
      @skill = Skill.find_by_slug(params[:skill_id])
      @jobs = @skill.jobs.order(@order_by + " " + @direction)
      breadcrumbs("first_collection", "skills")
      breadcrumbs("first_resource", @skill)
      breadcrumbs("second_collection", "jobs")
    elsif !params[:software_id].nil?
      @software = Software.find_by_slug(params[:software_id]) rescue Software.find_by_id(params[:software_id])
      @jobs = @software.jobs.order(@order_by + " " + @direction)
      breadcrumbs("first_collection", "softwares")
      breadcrumbs("first_resource", @software)
      breadcrumbs("second_collection", "jobs")
    elsif !params[:year_id].nil?
      @year = Year.new(params[:year_id])
      @jobs = @year.jobs
      if @direction == "DESC"
        @jobs.sort! { |a,b| b.send(@order_by) <=> a.send(@order_by) }
      else
        @jobs.sort! { |a,b| a.send(@order_by) <=> b.send(@order_by) }
      end
      breadcrumbs("first_collection", "years")
      breadcrumbs("first_resource", @year)
      breadcrumbs("second_collection", "jobs")
    elsif @user
      if @resume
        @jobs = @resume.jobs.order(@order_by + " " + @direction)
        breadcrumbs("first_collection", "jobs")
      else
        @jobs = @user.jobs.order(@order_by + " " + @direction)
      end
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
    @uncategorized_skills = @job.uncategorized_skills
    @softwares = @job.softwares.order("title ASC")
    @years = @job.years.sort { |a,b| a.value <=> b.value }
    @highlights = @job.highlights.order("skill_id")
    @disciplines = @job.disciplines
    breadcrumbs("first_collection", "jobs")
    breadcrumbs("first_resource", @job)

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    @job = Job.new
    @u_skills = @user.skills.order("title ASC")
    new_instance_vars
    breadcrumbs("first_collection", "jobs")

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
    edit_instance_vars
    breadcrumbs("first_collection", "jobs")
    breadcrumbs("first_resource", @job)

    respond_to do |format|
      format.html # edit.html.erb
      format.json  { render :json => @job }
    end
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(params[:job])
    @job.user_id = current_user.id
    if !params[:resume_id].nil?
      @resume = Resume.find(params[:resume_id])
    end
    @user = current_user

    respond_to do |format|
      if @job.save
        if @resume
          @r_job = ResumeJob.new({:resume_id => @resume.id, :job_id => @job.id})
          if @r_job.save
            logger.debug "Saved a ResumeJob"
          end
        end

        skills = params[:skills]
        if !skills.nil? && skills != ""
          skills = skills.split(',')
          save_skills(skills, @job, @user)
        end

        softwares = params[:softwares]
        if !softwares.nil? && softwares != ""
          softwares = softwares.split(',')
          save_softwares(softwares, @job, @user)
        end

        resume_ids = params[:resume_ids]
        if !resume_ids.nil? and resume_ids.size > 0
          save_resume_jobs(@job.id, resume_ids)
        end

        path = if @resume then job_path(:user_id => @user.id, :resume_id => @resume.id, :id => @job.id) else job_path(:user_id => @user.id, :id => @job.id) end
        if @user.jobs.size == 1
          flash[:notice] = "This is what a job page looks like. When you take a look at your resume, it'll show this job."
        else
          flash[:notice] = "Success. Job added."
        end
        format.html { redirect_to(path) }
        format.json  { render :json => @job, :status => :created, :location => @job }
      else
        new_instance_vars
        format.html { render :action => "new" }
        format.json  { render :json => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.json
  def update
    @job = Job.find(params[:id])
    skills = params[:skills] || []
    if skills != []
      skills = skills.split(',')
    end
    save_skills(skills, @job, current_user)
    
    softwares = params[:softwares] || []
    if softwares != []
      softwares = softwares.split(',')
    end
    save_softwares(softwares, @job, current_user)

    resume_ids = params[:resume_ids] || []
    rj_ids = @job.resume_jobs.flat_map { |rj| rj.resume_id.to_s }
    diff = rj_ids - resume_ids
    if diff.count > 0
      delete_resume_jobs(@job.id, diff)
    end
    if resume_ids.size > 0
      save_resume_jobs(@job.id, resume_ids)
    end

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to(job_path(current_user, @job, :notice => 'Job was successfully updated.')) }
        format.json  { head :ok }
      else
        edit_instance_vars
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

  def confirm_delete
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html { render :action => "confirm_delete" }
    end
  end
end

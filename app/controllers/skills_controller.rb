class SkillsController < ApplicationController
  before_filter :require_known_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :require_user_match, :only => [:new, :create, :edit, :update, :destroy]

  def save_user_skill(skill, user, discipline_id = nil)
    us = user.user_skills.find_by_skill_id(skill.id)
    if us.nil?
      us = UserSkill.new({:user_id => user.id, :skill_id => skill.id, :discipline_id => discipline_id})
      if us.save
        logger.debug "Saved a user_skill!"
        logger.debug us.id
      else
        return false
      end
    end
  end

  # GET /skills
  # GET /skills.json
  def index
    @order_by = !params[:order_by].nil? ? params[:order_by] : "title"
    @direction = !params[:direction].nil? ? params[:direction] : "ASC"

    if !params[:job_id].nil?
      @job = Job.find_by_id(params[:job_id])
      @skills = @job.skills.order(@order_by + " " + @direction)
      breadcrumbs("first_collection", "jobs")
      breadcrumbs("first_resource", @job)
      breadcrumbs("second_collection", "skills")
    elsif !params[:year_id].nil?
      @year = Year.new(params[:year_id])
      @skills = @year.skills
      if @direction == "DESC"
        @skills.sort! { |a,b| b.send(@order_by) <=> a.send(@order_by) }
      else
        @skills.sort! { |a,b| a.send(@order_by) <=> b.send(@order_by) }
      end
      breadcrumbs("first_collection", "years")
      breadcrumbs("first_resource", @year)
      breadcrumbs("second_collection", "skills")
    elsif @resume
      @skills = @resume.skills
      if @direction == "DESC"
        @skills.sort! { |a,b| b.send(@order_by) <=> a.send(@order_by) }
      else
        @skills.sort! { |a,b| a.send(@order_by) <=> b.send(@order_by) }
      end
      breadcrumbs("first_collection", "skills")
    elsif @user
      @skills = @user.skills.order(@order_by + " " + @direction)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @skills }
    end
  end

  # GET /skills/1
  # GET /skills/1.json
  def show
    @skill = Skill.find_by_slug(params[:id])
    @jobs = @skill.jobs.order("end_year DESC, end_month DESC")
    @years = @skill.years.sort_by { |y| -y.value }
    @highlights = @skill.highlights
    breadcrumbs("first_collection", "skills")
    breadcrumbs("first_resource", @skill)

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @skill }
    end
  end

  # GET /skills/new
  # GET /skills/new.json
  def new
    @skill = flash[:skill] || Skill.new
    @disciplines = @user.disciplines
    @url = skills_path({:user_id => current_user.id})
    breadcrumbs("first_collection", "skills")

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @skill }
    end
  end

  # GET /skills/1/edit
  def edit
    @skill = flash[:skill] || Skill.find_by_slug(params[:id])
    @disciplines = @user.disciplines
    @url = skill_path({:user_id => @user.id, :id => @skill.id})
    breadcrumbs("first_collection", "skills")
    breadcrumbs("first_resource", @skill)
  end

  # POST /skills
  # POST /skills.json
  def create
    @skill = Skill.find_by_title(params[:skill][:title])
    if @skill.nil?
      @skill = Skill.new(params[:skill])
      # TODO: this should probably go in the model
      @skill.slug = @skill.title.gsub(" ","-")
    end

    respond_to do |format|
      if @skill.save
        save_user_skill(@skill, current_user, params[:discipline_id])
        format.html { redirect_to(user_path(current_user), :notice => 'Skill was successfully added.') }
        format.json  { render :json => @skill, :status => :created, :location => @skill }
      else
        flash[:skill] = @skill
        format.html { redirect_to new_skill_path }
        format.json  { render :json => @skill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /skills/1
  # PUT /skills/1.json
  def update
    @skill = Skill.find(params[:id])

    respond_to do |format|
      if @skill.update_attributes(params[:skill])
        format.html { redirect_to(@skill, :notice => 'Skill was successfully updated.') }
        format.json  { head :ok }
      else
        flash[:skill] = @skill
        format.html { redirect_to edit_skill_path({:user_id => @user.id, :id => @skill.slug}) }
        format.json  { render :json => @skill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /skills/1
  # DELETE /skills/1.json
  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy

    respond_to do |format|
      format.html { redirect_to(skills_url) }
      format.json  { head :ok }
    end
  end

  def confirm_delete
    @skill = Skill.find_by_slug(params[:id])
    @user_skill = @user.user_skills.find_by_skill_id(@skill.id)

    respond_to do |format|
      format.html { render :action => "confirm_delete" }
    end
  end
end

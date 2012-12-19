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
    elsif !params[:year_id].nil?
        @year = Year.find_by_value(params[:year_id])
        @skills = @year.skills.order(@order_by + " " + @direction)
    elsif @resume
        @skills = @resume.skills
        if @direction == "DESC"
          @skills.sort! { |a,b| b.send(@order_by) <=> a.send(@order_by) }
        else
          @skills.sort! { |a,b| a.send(@order_by) <=> b.send(@order_by) }
        end
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
    @skill = Skill.find(params[:id])
    @jobs = @skill.jobs.order("end_year DESC, end_month DESC")
    @years = @skill.years
    @highlights = Highlight.find_all_by_skill_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @skill }
    end
  end

  # GET /skills/new
  # GET /skills/new.json
  def new
    @skill = Skill.new
    @disciplines = @user.disciplines

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @skill }
    end
  end

  # GET /skills/1/edit
  def edit
    @skill = Skill.find(params[:id])
    @disciplines = @user.disciplines
  end

  # POST /skills
  # POST /skills.json
  def create
    @skill = Skill.find_by_title(params[:skill][:title])
    if @skill.nil?
      @skill = Skill.new(params[:skill])
      @skill.slug = @skill.slug.gsub(" ","-")
    end

    respond_to do |format|
      if @skill.save
        save_user_skill(@skill, current_user, params[:discipline_id])
        format.html { redirect_to(user_path(current_user), :notice => 'Skill was successfully added.') }
        format.json  { render :json => @skill, :status => :created, :location => @skill }
      else
        format.html { render :action => "new" }
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
        format.html { render :action => "edit" }
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
end

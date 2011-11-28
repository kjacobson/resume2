class SkillsController < ApplicationController
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
    else
        @skills = Skill.find(:all, :order => @order_by + " " + @direction)
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

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @skill }
    end
  end

  # GET /skills/new
  # GET /skills/new.json
  def new
    @skill = Skill.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @skill }
    end
  end

  # GET /skills/1/edit
  def edit
    @skill = Skill.find(params[:id])
  end

  # POST /skills
  # POST /skills.json
  def create
    @skill = Skill.new(params[:skill])
    @skill.user_id = current_user.id

    respond_to do |format|
      if @skill.save
        format.html { redirect_to(@skill, :notice => 'Skill was successfully created.') }
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

class DisciplinesController < ApplicationController
  before_filter :require_known_user, :only => [:new, :create, :edit, :update, :destroy]

  # GET /disciplines
  # GET /disciplines.json
  def index
    @order_by = !params[:order_by].nil? ? params[:order_by] : "title"
    @direction = !params[:direction].nil? ? params[:direction] : "ASC"
    if !params[:job_id].nil?
      @job = Job.find(params[:job_id])
      @disciplines = @job.disciplines.order(@order_by + " " + @direction)
      breadcrumbs("first_collection", "jobs")
      breadcrumbs("first_resource", @job)
      breadcrumbs("second_collection", "disciplines")
    elsif @resume
      @disciplines = @resume.disciplines
      # if we're going to send() @order_by, then we need to check it against a whitelist
      if @direction == "ASC"
        @disciplines.sort { |a, b| a.send(@order_by) <=> b.send(@order_by) }
      else
        @disciplines.sort { |a, b| b.send(@order_by) <=> a.send(@order_by) }
      end
      breadcrumbs("first_collection", "disciplines")
    elsif @user
      @disciplines = @user.disciplines.order(@order_by + " " + @direction)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @disciplines }
    end
  end

  # GET /disciplines/1
  # GET /disciplines/1.json
  def show
    @discipline = Discipline.find(params[:id])
    @skills = @discipline.skills
    breadcrumbs("first_collection", "disciplines")
    breadcrumbs("first_resource", @discipline)

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @discipline }
    end
  end

  # GET /disciplines/new
  # GET /disciplines/new.json
  def new
    @discipline = flash[:discipline] || Discipline.new
    @skills = @user.skills
    @selected_skills = []
    @url = disciplines_path(@user)
    breadcrumbs("first_collection", "disciplines")

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @discipline }
    end
  end

  # GET /disciplines/1/edit
  def edit
    @discipline = Discipline.find(params[:id])
    @skills = @user.skills
    @selected_skills = @discipline.skills || []
    @url = discipline_path(:user => @user, :discipline_id => @discipline.id)
    breadcrumbs("first_collection", "disciplines")
    breadcrumbs("first_resource", @discipline)

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @discipline }
    end
  end

  # POST /disciplines
  # POST /disciplines.json
  def create
    @discipline = Discipline.new(params[:discipline])
    if !@resume.nil?
      @discipline.resume_id = @resume.id
    end

    respond_to do |format|
      if @discipline.save
        @skills = params[:skills]
        @user_skills = @user.user_skills
        @skills.each do |sk|
          skill = Skill.find_by_title(sk)
          user_skill = @user_skills.select { |us| us.skill_id == skill.id }.first
          if !user_skill.nil?
            user_skill.update_attributes(:discipline_id => @discipline.id)
          end
        end
        format.html { redirect_to(@discipline, :notice => 'Discipline was successfully created.') }
        format.json  { render :json => @discipline, :status => :created, :location => @discipline }
      else
        flash[:discipline] = @discipline
        format.html { redirect_to(new_discipline_path) }
        format.json  { render :json => @discipline.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /disciplines/1
  # PUT /disciplines/1.json
  def update
    @discipline = Discipline.find(params[:id])
    if !params[:skills].nil?
      @skills = params[:skills]
      @user_skills = @user.user_skills
      @skills.each do |sk|
        skill = Skill.find_by_title(sk)
        user_skill = @user_skills.select { |us| us.skill_id == skill.id }.first
        if !user_skill.nil?
          user_skill.update_attributes(:discipline_id => @discipline.id)
        end
      end
    end

    respond_to do |format|
      if @discipline.update_attributes(params[:discipline])
        format.html { redirect_to(discipline_path(:user_id => @user.id, :id => @discipline.id), :notice => 'Discipline was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { redirect_to discipline_path }
        format.json  { render :json => @discipline.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /disciplines/1
  # DELETE /disciplines/1.json
  def destroy
    @discipline = Discipline.find(params[:id])
    @discipline.destroy

    respond_to do |format|
      format.html { redirect_to(disciplines_url) }
      format.json  { head :ok }
    end
  end

  def confirm_delete
    @discipline = Discipline.find(params[:id])

    respond_to do |format|
      format.html { render :action => "confirm_delete" }
    end
  end
end

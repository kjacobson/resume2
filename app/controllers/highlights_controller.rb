class HighlightsController < ApplicationController
  before_filter :require_known_user, :only => [:new, :create, :edit, :update, :destroy]

  # GET /highlights
  # GET /highlights.json
  def index
    @order_by = !params[:order_by].nil? ? params[:order_by] : "id"
    @direction = !params[:direction].nil? ? params[:direction] : "ASC"
    if !params[:job_id].nil?
      @job = Job.find(params[:job_id])
    end
    if !params[:skill_id].nil?
      @skill = Skill.find_by_slug(params[:skill_id])
    end
    if !@job.nil?
      @highlights = @job.highlights.order(@order_by + " " + @direction)
    elsif !@skill.nil?
      @highlights = @skill.highlights.order(@order_by + " " + @direction)
    else
      @highlights = @user.highlights.order(@order_by + " " + @direction)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @highlights }
    end
  end

  # GET /highlights/1
  # GET /highlights/1.json
  def show
    @highlight = Highlight.find(params[:id])
    @job = @highlight.job
    @skill = @highlight.skill

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @highlight }
    end
  end

  # GET /highlights/new
  # GET /highlights/new.json
  def new
    @highlight = Highlight.new
    @url = highlights_path(@user)
    if !params[:job_id].nil?
      @job = Job.find(params[:job_id])
    end
    if !params[:skill_id].nil?
      @skill = Skill.find(params[:skill_id])
    end
    @jobs = @user.jobs.order("title ASC")
    @skills = @user.skills.order("title ASC")

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @highlight }
    end
  end

  # GET /highlights/1/edit
  def edit
    @highlight = Highlight.find(params[:id])
    @url = highlight_path(@user, @highlight)
    @job = @highlight.job
    @skill = @highlight.skill

    @jobs = @user.jobs.order("title ASC")
    @skills = @user.skills.order("title ASC")

    respond_to do |format|
      format.html # edit.html.erb
      format.json  { render :json => @highlight }
    end
  end

  # POST /highlights
  # POST /highlights.json
  def create
    @highlight = Highlight.new(params[:highlight])

    respond_to do |format|
      if @highlight.save
        format.html { redirect_to(highlight_path(@user, @highlight), :notice => 'Highlight was successfully created.') }
        format.json  { render :json => @highlight, :status => :created, :location => @highlight }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @highlight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /highlights/1
  # PUT /highlights/1.json
  def update
    @highlight = Highlight.find(params[:id])

    respond_to do |format|
      if @highlight.update_attributes(params[:highlight])
        format.html { redirect_to(highlight_path(@user, @highlight), :notice => 'Highlight was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @highlight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /highlights/1
  # DELETE /highlights/1.json
  def destroy
    @highlight = Highlight.find(params[:id])
    @highlight.destroy

    respond_to do |format|
      format.html { redirect_to(highlights_url) }
      format.json  { head :ok }
    end
  end

  def confirm_delete
    @highlight = Highlight.find(params[:id])

    respond_to do |format|
      format.html { render :action => "confirm_delete" }
    end
  end
end

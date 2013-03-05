class SoftwaresController < ApplicationController
  before_filter :require_known_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :require_user_match, :only => [:new, :create, :edit, :update, :destroy]

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

  # GET /softwares
  # GET /softwares.json
  def index
    @order_by = !params[:order_by].nil? ? params[:order_by] : "title"
    @direction = !params[:direction].nil? ? params[:direction] : "ASC"

    if !params[:job_id].nil?
      @job = Job.find_by_id(params[:job_id])
      @softwares = @job.softwares.order(@order_by + " " + @direction)
      breadcrumbs("first_collection", "jobs")
      breadcrumbs("first_resource", @job)
      breadcrumbs("second_collection", "softwares")
    elsif !params[:year_id].nil?
      @year = Year.new(params[:year_id])
      @softwares = @year.softwares
      if @direction == "DESC"
        @softwares.sort! { |a,b| b.send(@order_by) <=> a.send(@order_by) }
      else
        @softwares.sort! { |a,b| a.send(@order_by) <=> b.send(@order_by) }
      end
      breadcrumbs("first_collection", "years")
      breadcrumbs("first_resource", @year)
      breadcrumbs("second_collection", "softwares")
    elsif @resume
      @softwares = @resume.softwares
      if @direction == "DESC"
        @softwares.sort! { |a,b| b[@order_by] <=> a[@order_by] }
      else
        @softwares.sort! { |a,b| a[@order_by] <=> b[@order_by] }
      end
      breadcrumbs("first_collection", "softwares")
    elsif @user
      @softwares = @user.softwares.order(@order_by + " " + @direction)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @softwares }
    end
  end

  # GET /softwares/1
  # GET /softwares/1.json
  def show
    @software = Software.find_by_slug(params[:id])
    @jobs = @software.jobs.order("end_year DESC, end_month DESC")
    @years = @software.years
    breadcrumbs("first_collection", "softwares")
    breadcrumbs("first_resource", @software)

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @software }
    end
  end

  # GET /softwares/new
  # GET /softwares/new.json
  def new
    @software = Software.new
    @url = softwares_path({:user_id => current_user.id})

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @software }
    end
  end

  # GET /softwares/1/edit
  def edit
    @software = Software.find_by_slug(params[:id])
    @url = software_path({:user_id => current_user.id, :id => @software.id})
  end

  # POST /softwares
  # POST /softwares.json
  def create                                      
    @software = Software.find_by_title(params[:software][:title])
    if @software.nil?
      @software = Software.new(params[:software])
      @software.slug = @software.slug.gsub(" ","-")
    end

    respond_to do |format|
      if @software.save
        save_user_software(@software, current_user)
        format.html { redirect_to(user_path(current_user), :notice => 'Software was successfully added.') }
        format.json  { render :json => @software, :status => :created, :location => @software }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @software.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /softwares/1
  # PUT /softwares/1.json
  def update
    @software = Software.find(params[:id])

    respond_to do |format|
      if @software.update_attributes(params[:software])
        format.html { redirect_to(@software, :notice => 'Software was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @software.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /softwares/1
  # DELETE /softwares/1.json
  def destroy
    @software = Software.find(params[:id])
    @software.destroy

    respond_to do |format|
      format.html { redirect_to(softwares_url) }
      format.json  { head :ok }
    end
  end

  def confirm_delete
    @software = Software.find_by_slug(params[:id])

    respond_to do |format|
      format.html { render :action => "confirm_delete" }
    end
  end
end

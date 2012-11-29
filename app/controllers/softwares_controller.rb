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
    elsif !params[:year_id].nil?
        @year = Year.find_by_value(params[:year_id])
        @softwares = @year.softwares.order(@order_by + " " + @direction)
    else
        @softwares = Software.find(:all, :order => @order_by + " " + @direction)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @softwares }
    end
  end

  # GET /softwares/1
  # GET /softwares/1.json
  def show
    if !params[:user_id].nil?
      @user = User.find(params[:user_id])
      if !params[:resume_id].nil?
        @resume = Resume.find(params[:resume_id])
      end
    end
    @software = Software.find_by_slug(params[:id])
    @jobs = @software.jobs.order("end_year DESC, end_month DESC")
    @years = @software.years

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @software }
    end
  end

  # GET /softwares/new
  # GET /softwares/new.json
  def new
    @software = Software.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @software }
    end
  end

  # GET /softwares/1/edit
  def edit
    @software = Software.find(params[:id])
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
end

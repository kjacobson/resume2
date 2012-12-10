class YearsController < ApplicationController

  # GET /years
  # GET /years.xml
  def index
    @order_by = !params[:order_by].nil? ? params[:order_by] : "value"
    @direction = !params[:direction].nil? ? params[:direction] : "DESC"
    if !params[:job_id].nil?
        @job = Job.find_by_id(params[:job_id])
        @years = @job.years.order(@order_by + " " + @direction)
    elsif !params[:skill_id].nil?
        @skill = Skill.find_by_id(params[:skill_id])
        @years = @skill.years.sort! { |a,b| b.value <=> a.value }
    elsif !params[:software_id].nil?
        @software = Software.find_by_id(params[:software_id])
        @years = @software.years.sort! { |a,b| b.value <=> a.value }
    elsif @resume
        @jobs = @resume.jobs
        @years = @resume.years
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @years }
    end
  end

  # GET /years/1
  # GET /years/1.xml
  def show
    @year = Year.new(params[:id])
    @jobs = @year.jobs.order("end_year DESC")
    @skills = @year.skills.sort! { |a,b| a.title <=> b.title }
    @softwares = @year.softwares.sort! { |a,b| a.title <=> b.title }

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @year }
    end
  end
end
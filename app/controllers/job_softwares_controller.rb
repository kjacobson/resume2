class JobSoftwaresController < ApplicationController             
  def create
    @job_software = JobSoftware.new(params[:job_software])
    @job_software.user_id = current_user.id

    respond_to do |format|
      if @job_software.save
        format.html {  }
        format.json  { render :json => @job_software, :status => :created, :location => @job_software }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @job_software.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @job_software = JobSoftware.find(params[:id])

    respond_to do |format|
      if @job_software.update_attributes(params[:job_software])
        format.html { }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @job_software.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @job_software = JobSoftware.find(params[:id])
    @job_software.destroy

    respond_to do |format|
      format.html {  }
      format.json  { head :ok }
    end
  end
end

class JobSkillsController < ApplicationController
  def create
    @job_skill = JobSkill.new(params[:job_skill])
    @job_skill.user_id = current_user.id

    respond_to do |format|
      if @job_skill.save
        format.html {  }
        format.json  { render :json => @job_skill, :status => :created, :location => @job_skill }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @job_skill.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @job_skill = JobSkill.find(params[:id])

    respond_to do |format|
      if @job_skill.update_attributes(params[:job_skill])
        format.html { }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @job_skill.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @job_skill = JobSkill.find(params[:id])
    @job_skill.destroy

    respond_to do |format|
      format.html {  }
      format.json  { head :ok }
    end
  end
end

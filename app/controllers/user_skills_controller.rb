class UserSkillsController < ApplicationController
  # POST /user_skills
  # POST /user_skills.json
  def create
    @user_skill = UserSkill.new(params[:user_skill])

    respond_to do |format|
      if @user_skill.save
        format.html { redirect_to @user_skill, :notice => 'Skill was successfully added.' }
        format.json { render :json  => @user_skill, :status => :created, :location => @user_skill }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user_skill.errors, :status =>:unprocessable_entity }
      end
    end
  end

  # PUT /user_skills/1
  # PUT /user_skills/1.json
  def update
    @user_skill = UserSkill.find(params[:id])

    respond_to do |format|
      if @user_skill.update_attributes(params[:user_skill])
        format.html { redirect_to request.referrer, :notice => @user_skill.discipline ? "Success. &ldquo;#{@user_skill.skill.title}&rdquo; is now categorized under &ldquo;#{@user_skill.discipline.title.titleize }&rdquo;." : "Success. #{@user_skill.skill.title } is no longer associated with a discipline."}
        format.json { render :json => true }
      else
        format.html { redirect_to request.referrer }
        format.json { render :json => @user_skill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_skills/1
  # DELETE /user_skills/1.json
  def destroy
    @user_skill = UserSkill.find(params[:id])
    @user_skill.destroy

    respond_to do |format|
      format.html { redirect_to user_skills_url }
      format.json { head :ok }
    end
  end
end

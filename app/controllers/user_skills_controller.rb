class UserSkillsController < ApplicationController
  # POST /user_skills
  # POST /user_skills.json
  def create
    @user_skill = UserSkill.new(params[:user_skill])

    respond_to do |format|
      if @user_skill.save
        format.html { redirect_to @user_skill, :notice => 'User skill was successfully created.' }
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
        format.html { redirect_to @user_skill, :notice => 'User skill was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
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

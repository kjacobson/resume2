class UserSoftwaresController < ApplicationController
  # POST /user_softwares
  # POST /user_softwares.json
  def create
    @user_software = UserSoftware.new(params[:user_software])

    respond_to do |format|
      if @user_software.save
        format.html { redirect_to @user_software, :notice => 'User software was successfully created.' }
        format.json { render :json => @user_software, :status => :created, :location => @user_software }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user_software.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_softwares/1
  # PUT /user_softwares/1.json
  def update
    @user_software = UserSoftware.find(params[:id])

    respond_to do |format|
      if @user_software.update_attributes(params[:user_software])
        format.html { redirect_to @user_software, :notice => 'User software was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user_software.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_softwares/1
  # DELETE /user_softwares/1.json
  def destroy
    @user_software = UserSoftware.find(params[:id])
    @user_software.destroy

    respond_to do |format|
      format.html { redirect_to user_softwares_url }
      format.json { head :ok }
    end
  end
end

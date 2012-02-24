class UsersController < ApplicationController
  def index
    @users = User.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @jobs }
    end
  end

  def new
    @user = User.new
    @resume = Resume.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      if !params[:user][:resume_name].nil? and !params[:user][:resume_name].nil?
          @resume = Resume.new(params[:user][:resume_name])
          if @resume.save
            redirect_to resume_path(@resume)
          else
            redirect_to user_path(@user)
          end
      end

      flash[:notice] = "Account registered!"
    else
      render :action => :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to user_path(@user)
    else
      render :action => :edit
    end
  end
end
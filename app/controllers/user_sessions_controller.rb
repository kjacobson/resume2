class UserSessionsController < ApplicationController
  skip_before_filter :require_user_match, :only => [:new, :create, :destroy]
  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new
    errors = flash[:us_errors] || []
    errors.each do |k, v|
      @user_session.errors.add(k, v)
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    pass = false
    email = params[:user_session][:email]
    validation_key = params[:user_session][:validation_key]
    @user = User.find_by_email(email)
    @user_session = UserSession.create(params[:user_session])
    if @user && @validation = LoginValidation.find_by_hash(validation_key)
      if !@validation.expired? && @validation.user_id == @user.id
        pass = true
        @hash = User.generate_hash
        @user.password = @hash
        @user.save
        user_session = params[:user_session]
        user_session[:password] = @hash
        @user_session = UserSession.create(user_session, true)
      else
        @user_session.errors[:base] << t(:attributes, :scope => [:activerecord, :attributes, :user_session, :errors])
      end
    else
      if @user
        send_login_email(@user)
        redirect_to(:homepage, :notice => "We sent your login email. Just click the link and you&rsquo;ll be logged in.") and return
      else
        @user_session.errors[:email] << t(:email, :scope => [:activerecord, :attributes, :user_session, :errors])
      end
    end

    respond_to do |format|
      if pass && @user_session.save
        @validation.destroy
        # TODO: smarter post-login logic
        format.html { redirect_to(user_path(@user_session.user), :notice => 'Login Successful') }
        format.xml  { render :xml => @user_session, :status => :created, :location => @user_session }
      else
        format.html {
          flash[:us_errors] = @user_session.errors
          redirect_to login_path(:validation_key => validation_key)
        }
        format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy
    end

    respond_to do |format|
      format.html { redirect_to(:homepage, :notice => 'You&rsquo;ve been signed out. Thanks for stopping by.') }
      format.xml  { head :ok }
    end
  end

  def send_login_email(user)
    @user = user
    existing = LoginValidation.find_all_by_user_id(@user.id)
    existing.each do |ex|
      ex.destroy
    end
    @validation = LoginValidation.new(:user_id => @user.id, :expiration => Date.tomorrow())
    if @validation.save
      UserMailer.login_email(@user, @validation).deliver
    end
  end
end

class HomeController < ApplicationController
  def index
    if current_user
      redirect_to user_path(current_user) and return
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @jobs }
    end
  end
end

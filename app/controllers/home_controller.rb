class HomeController < ApplicationController
  skip_before_filter :require_known_user
  skip_before_filter :require_access_key

  def index
    if current_user
      flash[:notice] = flash[:notice]
      redirect_to user_path(current_user) and return
    end
    @demo = Demo.first

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @jobs }
    end
  end

  def disclaimer
  end
end

class LinksController < ApplicationController
  before_filter :require_known_user
  before_filter :require_user_match

  # GET /links
  # GET /links.json
  def index
    @order_by = !params[:order_by].nil? ? params[:order_by] : "expiration"
    @direction = !params[:direction].nil? ? params[:direction] : "DESC"
    if @resume
      @links = @resume.links.order(@order_by + " " + @direction)
    else
      @links = @user.links.sort { |a,b| b.send(@order_by) <=> a.send(@order_by) }
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @links }
    end
  end

  # GET /links/1
  # GET /links/1.json
  def show
    @link = Link.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/new
  # GET /links/new.json
  def new
    @link = Link.new
    @user_id = @user ? @user.id : nil
    @resume_id = @resume ? @resume.id : nil
    @url = resume_links_path(@user, @resume)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(params[:link])

    respond_to do |format|
      if @link.save
        format.html { redirect_to resume_links_path(@user, @link.resume), notice: 'Link was successfully created.' }
        format.json { render json: @link, status: :created, location: @link }
      else
        format.html { render action: "new" }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.json
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        format.html { redirect_to resume_links_path(@user, @link.resume), notice: 'Link was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to links_url }
      format.json { head :ok }
    end
  end

  def confirm_delete
    @link = Link.find(params[:id])

    respond_to do |format|
      format.html { render :action => "confirm_delete" }
    end
  end
end

class ResumeHighlightsController < ApplicationController
  # GET /resume_highlights
  # GET /resume_highlights.xml
  def index
    @resume_highlights = ResumeHighlight.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resume_highlights }
    end
  end

  # GET /resume_highlights/1
  # GET /resume_highlights/1.xml
  def show
    @resume_highlight = ResumeHighlight.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resume_highlight }
    end
  end

  # GET /resume_highlights/new
  # GET /resume_highlights/new.xml
  def new
    @resume_highlight = ResumeHighlight.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resume_highlight }
    end
  end

  # GET /resume_highlights/1/edit
  def edit
    @resume_highlight = ResumeHighlight.find(params[:id])
  end

  # POST /resume_highlights
  # POST /resume_highlights.xml
  def create
    @resume_highlight = ResumeHighlight.new(params[:resume_highlight])

    respond_to do |format|
      if @resume_highlight.save
        format.html { redirect_to(@resume_highlight, :notice => 'Resume highlight was successfully created.') }
        format.xml  { render :xml => @resume_highlight, :status => :created, :location => @resume_highlight }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resume_highlight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resume_highlights/1
  # PUT /resume_highlights/1.xml
  def update
    @resume_highlight = ResumeHighlight.find(params[:id])

    respond_to do |format|
      if @resume_highlight.update_attributes(params[:resume_highlight])
        format.html { redirect_to(@resume_highlight, :notice => 'Resume highlight was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resume_highlight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resume_highlights/1
  # DELETE /resume_highlights/1.xml
  def destroy
    @resume_highlight = ResumeHighlight.find(params[:id])
    @resume_highlight.destroy

    respond_to do |format|
      format.html { redirect_to(resume_highlights_url) }
      format.xml  { head :ok }
    end
  end
end

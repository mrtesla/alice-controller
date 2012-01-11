class Core::ApplicationsController < ApplicationController
  before_filter :authenticate_user!

  # GET /core/applications
  # GET /core/applications.json
  def index
    @core_applications = Core::Application.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @core_applications }
    end
  end

  # GET /core/applications/1
  # GET /core/applications/1.json
  def show
    @core_application = Core::Application.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @core_application }
    end
  end

  # GET /core/applications/new
  # GET /core/applications/new.json
  def new
    @core_application = Core::Application.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @core_application }
    end
  end

  # GET /core/applications/1/edit
  def edit
    @core_application = Core::Application.find(params[:id])
  end

  # POST /core/applications
  # POST /core/applications.json
  def create
    @core_application = Core::Application.new(params[:core_application])

    respond_to do |format|
      if @core_application.save
        format.html { redirect_to @core_application, notice: 'Application was successfully created.' }
        format.json { render json: @core_application, status: :created, location: @core_application }
      else
        format.html { render action: "new" }
        format.json { render json: @core_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /core/applications/1
  # PUT /core/applications/1.json
  def update
    @core_application = Core::Application.find(params[:id])

    respond_to do |format|
      if @core_application.update_attributes(params[:core_application])
        format.html { redirect_to @core_application, notice: 'Application was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @core_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/applications/1/cache
  # DELETE /core/applications/1/cache.json
  def bust_cache
    @core_application = Core::Application.find(params[:id])
    @core_application.bust_cache!

    respond_to do |format|
      format.html { redirect_to @core_application, notice: 'Cache was successfully busted.' }
      format.json { head :ok }
    end
  end

  # DELETE /core/applications/1
  # DELETE /core/applications/1.json
  def destroy
    @core_application = Core::Application.find(params[:id])
    @core_application.destroy

    respond_to do |format|
      format.html { redirect_to core_applications_url }
      format.json { head :ok }
    end
  end
end

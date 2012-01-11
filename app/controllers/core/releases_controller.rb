class Core::ReleasesController < ApplicationController
  # GET /core/releases
  # GET /core/releases.json
  def index
    @core_releases = Core::Release.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @core_releases }
    end
  end

  # GET /core/releases/1
  # GET /core/releases/1.json
  def show
    @core_release = Core::Release.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @core_release }
    end
  end

  # GET /core/releases/new
  # GET /core/releases/new.json
  def new
    @core_release = Core::Release.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @core_release }
    end
  end

  # GET /core/releases/1/edit
  def edit
    @core_release = Core::Release.find(params[:id])
  end

  # POST /core/releases
  # POST /core/releases.json
  def create
    @core_release = Core::Release.new(params[:core_release])

    respond_to do |format|
      if @core_release.save
        format.html { redirect_to @core_release, notice: 'Release was successfully created.' }
        format.json { render json: @core_release, status: :created, location: @core_release }
      else
        format.html { render action: "new" }
        format.json { render json: @core_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /core/releases/1
  # PUT /core/releases/1.json
  def update
    @core_release = Core::Release.find(params[:id])

    respond_to do |format|
      if @core_release.update_attributes(params[:core_release])
        format.html { redirect_to @core_release, notice: 'Release was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @core_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/releases/1
  # DELETE /core/releases/1.json
  def destroy
    @core_release = Core::Release.find(params[:id])
    @core_release.destroy

    respond_to do |format|
      format.html { redirect_to core_releases_url }
      format.json { head :ok }
    end
  end
end

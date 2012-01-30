class Pluto::ProcessDefinitionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_core_application

  # GET /pluto/process_definitions
  # GET /pluto/process_definitions.json
  def index
    @pluto_process_definitions = collection.all

    respond_to do |format|
      format.json { render json: @pluto_process_definitions }
    end
  end

  # GET /pluto/process_definitions/1
  # GET /pluto/process_definitions/1.json
  def show
    @pluto_process_definition = collection.find(params[:id])

    respond_to do |format|
      format.json { render json: @pluto_process_definition }
    end
  end

  # GET /pluto/process_definitions/new
  # GET /pluto/process_definitions/new.json
  def new
    @pluto_process_definition = collection.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pluto_process_definition }
    end
  end

  # GET /pluto/process_definitions/1/edit
  def edit
    @pluto_process_definition = collection.find(params[:id])
  end

  # POST /pluto/process_definitions
  # POST /pluto/process_definitions.json
  def create
    @pluto_process_definition = collection.new(params[:pluto_process_definition])

    respond_to do |format|
      if @pluto_process_definition.save
        format.html do
          flash[:success] = 'Process definition was successfully created.'
          redirect_to @core_application
        end
        format.json { render json: @pluto_process_definition, status: :created, location: @pluto_process_definition }
      else
        format.html { render action: "new" }
        format.json { render json: @pluto_process_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pluto/process_definitions/1
  # PUT /pluto/process_definitions/1.json
  def update
    @pluto_process_definition = collection.find(params[:id])

    respond_to do |format|
      if @pluto_process_definition.update_attributes(params[:pluto_process_definition])
        format.html do
          flash[:success] = 'Process definition was successfully updated.'
          redirect_to @core_application
        end
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @pluto_process_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pluto/process_definitions/1
  # DELETE /pluto/process_definitions/1.json
  def destroy
    @pluto_process_definition = collection.find(params[:id])
    @pluto_process_definition.destroy

    respond_to do |format|
      format.html { redirect_to @core_application }
      format.json { head :ok }
    end
  end

private

  def collection
    @core_application.pluto_process_definitions
  end

end

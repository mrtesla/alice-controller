class Pluto::EnvironmentVariablesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_core_application

  # GET /pluto/environment_variables
  # GET /pluto/environment_variables.json
  def index
    @pluto_environment_variables = collection

    respond_to do |format|
      format.json { render json: @pluto_environment_variables }
    end
  end

  # GET /pluto/environment_variables/1
  # GET /pluto/environment_variables/1.json
  def show
    @pluto_environment_variable = collection.find(params[:id])

    respond_to do |format|
      format.json { render json: @pluto_environment_variable }
    end
  end

  # GET /pluto/environment_variables/new
  # GET /pluto/environment_variables/new.json
  def new
    @pluto_environment_variable = collection.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pluto_environment_variable }
    end
  end

  # GET /pluto/environment_variables/1/edit
  def edit
    @pluto_environment_variable = collection.find(params[:id])
  end

  # POST /pluto/environment_variables
  # POST /pluto/environment_variables.json
  def create
    @pluto_environment_variable = collection.build(params[:pluto_environment_variable])

    respond_to do |format|
      if @pluto_environment_variable.save
        format.html { redirect_to @core_application, notice: 'Environment variable was successfully created.' }
        format.json { render json: @pluto_environment_variable, status: :created, location: @pluto_environment_variable }
      else
        format.html { render action: "new" }
        format.json { render json: @pluto_environment_variable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pluto/environment_variables/1
  # PUT /pluto/environment_variables/1.json
  def update
    @pluto_environment_variable = collection.find(params[:id])

    respond_to do |format|
      if @pluto_environment_variable.update_attributes(params[:pluto_environment_variable])
        format.html { redirect_to @core_application, notice: 'Environment variable was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @pluto_environment_variable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pluto/environment_variables/1
  # DELETE /pluto/environment_variables/1.json
  def destroy
    @pluto_environment_variable = collection.find(params[:id])
    @pluto_environment_variable.destroy

    respond_to do |format|
      format.html { redirect_to @core_application }
      format.json { head :ok }
    end
  end

private

  def collection
    @core_application.pluto_environment_variables
  end

end

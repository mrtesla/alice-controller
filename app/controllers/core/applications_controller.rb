class Core::ApplicationsController < ApplicationController

  respond_to :html

  def index
    @applications = Core::Application.all
    respond_with(@applications)
  end

  def show
    @application = Core::Application.find(params[:id])
    respond_with @application
  end

  def new
    @application = Core::Application.new
    respond_with @application
  end

  def edit
  end

  def create
    @application = Core::Application.new(params[:core_application])
    @application.save
    respond_with @application
  end

  def update
  end

  def destroy
  end

end

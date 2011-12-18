class Core::MachinesController < ApplicationController

  respond_to :html

  def index
    @machines = Core::Machine.all
    respond_with(@machines)
  end

  def show
    @machine = Core::Machine.find(params[:id])
    respond_with @machine
  end

  def new
    @machine = Core::Machine.new
    respond_with @machine
  end

  def edit
  end

  def create
    @machine = Core::Machine.new(params[:core_machine])
    @machine.save
    respond_with @machine
  end

  def update
  end

  def destroy
  end

end

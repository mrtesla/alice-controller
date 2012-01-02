class Core::MachinesController < ApplicationController
  before_filter :authenticate_user!

  # GET /core/machines
  # GET /core/machines.json
  def index
    @core_machines = Core::Machine.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @core_machines }
    end
  end

  # GET /core/machines/1
  # GET /core/machines/1.json
  def show
    @core_machine = Core::Machine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @core_machine }
    end
  end

  # GET /core/machines/new
  # GET /core/machines/new.json
  def new
    @core_machine = Core::Machine.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @core_machine }
    end
  end

  # GET /core/machines/1/edit
  def edit
    @core_machine = Core::Machine.find(params[:id])
  end

  # POST /core/machines
  # POST /core/machines.json
  def create
    @core_machine = Core::Machine.new(params[:core_machine])

    respond_to do |format|
      if @core_machine.save
        format.html { redirect_to @core_machine, notice: 'Machine was successfully created.' }
        format.json { render json: @core_machine, status: :created, location: @core_machine }
      else
        format.html { render action: "new" }
        format.json { render json: @core_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /core/machines/1
  # PUT /core/machines/1.json
  def update
    @core_machine = Core::Machine.find(params[:id])

    respond_to do |format|
      if @core_machine.update_attributes(params[:core_machine])
        format.html { redirect_to @core_machine, notice: 'Machine was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @core_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/machines/1
  # DELETE /core/machines/1.json
  def destroy
    @core_machine = Core::Machine.find(params[:id])
    @core_machine.destroy

    respond_to do |format|
      format.html { redirect_to core_machines_url }
      format.json { head :ok }
    end
  end
end

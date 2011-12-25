class Http::PassersController < ApplicationController
  # GET /http/passers
  # GET /http/passers.json
  def index
    @http_passers = Http::Passer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @http_passers }
    end
  end

  # GET /http/passers/1
  # GET /http/passers/1.json
  def show
    @http_passer = Http::Passer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @http_passer }
    end
  end

  # GET /http/passers/new
  # GET /http/passers/new.json
  def new
    @http_passer = Http::Passer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @http_passer }
    end
  end

  # GET /http/passers/1/edit
  def edit
    @http_passer = Http::Passer.find(params[:id])
  end

  # POST /http/passers
  # POST /http/passers.json
  def create
    @http_passer = Http::Passer.new(params[:http_passer])

    respond_to do |format|
      if @http_passer.save
        format.html { redirect_to @http_passer, notice: 'Passer was successfully created.' }
        format.json { render json: @http_passer, status: :created, location: @http_passer }
      else
        format.html { render action: "new" }
        format.json { render json: @http_passer.errors, status: :unprocessable_entity }
      end
    end

    Http::Passer.send_to_redis
  end

  # PUT /http/passers/1
  # PUT /http/passers/1.json
  def update
    @http_passer = Http::Passer.find(params[:id])

    respond_to do |format|
      if @http_passer.update_attributes(params[:http_passer])
        format.html { redirect_to @http_passer, notice: 'Passer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @http_passer.errors, status: :unprocessable_entity }
      end
    end

    Http::Passer.send_to_redis
  end

  # DELETE /http/passers/1
  # DELETE /http/passers/1.json
  def destroy
    @http_passer = Http::Passer.find(params[:id])
    @http_passer.destroy

    respond_to do |format|
      format.html { redirect_to http_passers_url }
      format.json { head :ok }
    end

    Http::Passer.send_to_redis
  end
end

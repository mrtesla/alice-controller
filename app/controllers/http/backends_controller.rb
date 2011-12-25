class Http::BackendsController < ApplicationController
  # GET /http/backends
  # GET /http/backends.json
  def index
    @http_backends = Http::Backend.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @http_backends }
    end
  end

  # GET /http/backends/1
  # GET /http/backends/1.json
  def show
    @http_backend = Http::Backend.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @http_backend }
    end
  end

  # GET /http/backends/new
  # GET /http/backends/new.json
  def new
    @http_backend = Http::Backend.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @http_backend }
    end
  end

  # GET /http/backends/1/edit
  def edit
    @http_backend = Http::Backend.find(params[:id])
  end

  # POST /http/backends
  # POST /http/backends.json
  def create
    @http_backend = Http::Backend.new(params[:http_backend])

    respond_to do |format|
      if @http_backend.save
        format.html { redirect_to @http_backend, notice: 'Backend was successfully created.' }
        format.json { render json: @http_backend, status: :created, location: @http_backend }
      else
        format.html { render action: "new" }
        format.json { render json: @http_backend.errors, status: :unprocessable_entity }
      end
    end

    Http::Backend.send_to_redis
  end

  # PUT /http/backends/1
  # PUT /http/backends/1.json
  def update
    @http_backend = Http::Backend.find(params[:id])

    respond_to do |format|
      if @http_backend.update_attributes(params[:http_backend])
        format.html { redirect_to @http_backend, notice: 'Backend was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @http_backend.errors, status: :unprocessable_entity }
      end
    end

    Http::Backend.send_to_redis
  end

  # DELETE /http/backends/1
  # DELETE /http/backends/1.json
  def destroy
    @http_backend = Http::Backend.find(params[:id])
    @http_backend.destroy

    respond_to do |format|
      format.html { redirect_to http_backends_url }
      format.json { head :ok }
    end

    Http::Backend.send_to_redis
  end
end

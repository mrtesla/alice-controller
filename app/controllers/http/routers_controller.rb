class Http::RoutersController < ApplicationController
  # GET /http/routers
  # GET /http/routers.json
  def index
    @http_routers = Http::Router.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @http_routers }
    end
  end

  # GET /http/routers/1
  # GET /http/routers/1.json
  def show
    @http_router = Http::Router.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @http_router }
    end
  end

  # GET /http/routers/new
  # GET /http/routers/new.json
  def new
    @http_router = Http::Router.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @http_router }
    end
  end

  # GET /http/routers/1/edit
  def edit
    @http_router = Http::Router.find(params[:id])
  end

  # POST /http/routers
  # POST /http/routers.json
  def create
    @http_router = Http::Router.new(params[:http_router])

    respond_to do |format|
      if @http_router.save
        format.html { redirect_to @http_router, notice: 'Router was successfully created.' }
        format.json { render json: @http_router, status: :created, location: @http_router }
      else
        format.html { render action: "new" }
        format.json { render json: @http_router.errors, status: :unprocessable_entity }
      end
    end

    Http::Router.send_to_redis
  end

  # PUT /http/routers/1
  # PUT /http/routers/1.json
  def update
    @http_router = Http::Router.find(params[:id])

    respond_to do |format|
      if @http_router.update_attributes(params[:http_router])
        format.html { redirect_to @http_router, notice: 'Router was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @http_router.errors, status: :unprocessable_entity }
      end
    end

    Http::Router.send_to_redis
  end

  # DELETE /http/routers/1
  # DELETE /http/routers/1.json
  def destroy
    @http_router = Http::Router.find(params[:id])
    @http_router.destroy

    respond_to do |format|
      format.html { redirect_to http_routers_url }
      format.json { head :ok }
    end

    Http::Router.send_to_redis
  end
end

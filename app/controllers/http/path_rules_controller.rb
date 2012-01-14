class Http::PathRulesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_core_application

  # GET /http/path_rules
  # GET /http/path_rules.json
  def index
    @http_path_rules = collection.all

    respond_to do |format|
      format.json { render json: @http_path_rules }
    end
  end

  # GET /http/path_rules/1
  # GET /http/path_rules/1.json
  def show
    @http_path_rule = collection.find(params[:id])

    respond_to do |format|
      format.json { render json: @http_path_rule }
    end
  end

  # GET /http/path_rules/new
  # GET /http/path_rules/new.json
  def new
    @http_path_rule = collection.build
    @http_path_rule.path    = "/*"
    @http_path_rule.actions = [["forward", "web"]]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @http_path_rule }
    end
  end

  # GET /http/path_rules/1/edit
  def edit
    @http_path_rule = collection.find(params[:id])
  end

  # POST /http/path_rules
  # POST /http/path_rules.json
  def create
    if actions = params[:http_path_rule].try(:[], :actions)
      actions = JSON.load(actions) if String === actions
      params[:http_path_rule][:actions] = actions
    end

    @http_path_rule = collection.build(params[:http_path_rule])

    respond_to do |format|
      if @http_path_rule.save
        @core_application.send_to_redis
        format.html { redirect_to @core_application, notice: 'Path rule was successfully created.' }
        format.json { render json: @http_path_rule, status: :created, location: @http_path_rule }
      else
        format.html { render action: "new" }
        format.json { render json: @http_path_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /http/path_rules/1
  # PUT /http/path_rules/1.json
  def update
    if actions = params[:http_path_rule].try(:[], :actions)
      actions = JSON.load(actions) if String === actions
      params[:http_path_rule][:actions] = actions
    end

    @http_path_rule = collection.find(params[:id])

    respond_to do |format|
      if @http_path_rule.update_attributes(params[:http_path_rule])
        @core_application.send_to_redis
        format.html { redirect_to @core_application, notice: 'Path rule was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @http_path_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /http/path_rules/1
  # DELETE /http/path_rules/1.json
  def destroy
    @http_path_rule = collection.find(params[:id])
    @http_path_rule.destroy
    @core_application.send_to_redis

    respond_to do |format|
      format.html { redirect_to @core_application }
      format.json { head :ok }
    end
  end

private

  def collection
    @core_application.http_path_rules
  end

end

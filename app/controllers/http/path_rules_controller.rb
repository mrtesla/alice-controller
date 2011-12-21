class Http::PathRulesController < ApplicationController
  # GET /http/path_rules
  # GET /http/path_rules.json
  def index
    @http_path_rules = Http::PathRule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @http_path_rules }
    end
  end

  # GET /http/path_rules/1
  # GET /http/path_rules/1.json
  def show
    @http_path_rule = Http::PathRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @http_path_rule }
    end
  end

  # GET /http/path_rules/new
  # GET /http/path_rules/new.json
  def new
    @http_path_rule = Http::PathRule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @http_path_rule }
    end
  end

  # GET /http/path_rules/1/edit
  def edit
    @http_path_rule = Http::PathRule.find(params[:id])
  end

  # POST /http/path_rules
  # POST /http/path_rules.json
  def create
    if actions = params[:http_path_rule].try(:[], :actions)
      actions = JSON.load(actions) if String === actions
      params[:http_path_rule][:actions] = actions
    end

    @http_path_rule = Http::PathRule.new(params[:http_path_rule])

    respond_to do |format|
      if @http_path_rule.save
        format.html { redirect_to @http_path_rule, notice: 'Path rule was successfully created.' }
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

    @http_path_rule = Http::PathRule.find(params[:id])

    respond_to do |format|
      if @http_path_rule.update_attributes(params[:http_path_rule])
        format.html { redirect_to @http_path_rule, notice: 'Path rule was successfully updated.' }
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
    @http_path_rule = Http::PathRule.find(params[:id])
    @http_path_rule.destroy

    respond_to do |format|
      format.html { redirect_to http_path_rules_url }
      format.json { head :ok }
    end
  end
end

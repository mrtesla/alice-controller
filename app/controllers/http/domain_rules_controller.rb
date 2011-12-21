class Http::DomainRulesController < ApplicationController
  # GET /http/domain_rules
  # GET /http/domain_rules.json
  def index
    @http_domain_rules = Http::DomainRule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @http_domain_rules }
    end
  end

  # GET /http/domain_rules/1
  # GET /http/domain_rules/1.json
  def show
    @http_domain_rule = Http::DomainRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @http_domain_rule }
    end
  end

  # GET /http/domain_rules/new
  # GET /http/domain_rules/new.json
  def new
    @http_domain_rule = Http::DomainRule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @http_domain_rule }
    end
  end

  # GET /http/domain_rules/1/edit
  def edit
    @http_domain_rule = Http::DomainRule.find(params[:id])
  end

  # POST /http/domain_rules
  # POST /http/domain_rules.json
  def create
    @http_domain_rule = Http::DomainRule.new(params[:http_domain_rule])

    respond_to do |format|
      if @http_domain_rule.save
        format.html { redirect_to @http_domain_rule, notice: 'Domain rule was successfully created.' }
        format.json { render json: @http_domain_rule, status: :created, location: @http_domain_rule }
      else
        format.html { render action: "new" }
        format.json { render json: @http_domain_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /http/domain_rules/1
  # PUT /http/domain_rules/1.json
  def update
    @http_domain_rule = Http::DomainRule.find(params[:id])

    respond_to do |format|
      if @http_domain_rule.update_attributes(params[:http_domain_rule])
        format.html { redirect_to @http_domain_rule, notice: 'Domain rule was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @http_domain_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /http/domain_rules/1
  # DELETE /http/domain_rules/1.json
  def destroy
    @http_domain_rule = Http::DomainRule.find(params[:id])
    @http_domain_rule.destroy

    respond_to do |format|
      format.html { redirect_to http_domain_rules_url }
      format.json { head :ok }
    end
  end
end

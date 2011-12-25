require "spec_helper"

describe Http::DomainRulesController do
  describe "routing" do

    it "routes to #index" do
      get("/http/domain_rules").should route_to("http/domain_rules#index")
    end

    it "routes to #new" do
      get("/http/domain_rules/new").should route_to("http/domain_rules#new")
    end

    it "routes to #show" do
      get("/http/domain_rules/1").should route_to("http/domain_rules#show", :id => "1")
    end

    it "routes to #edit" do
      get("/http/domain_rules/1/edit").should route_to("http/domain_rules#edit", :id => "1")
    end

    it "routes to #create" do
      post("/http/domain_rules").should route_to("http/domain_rules#create")
    end

    it "routes to #update" do
      put("/http/domain_rules/1").should route_to("http/domain_rules#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/http/domain_rules/1").should route_to("http/domain_rules#destroy", :id => "1")
    end

  end
end

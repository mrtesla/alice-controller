require "spec_helper"

describe Http::PathRulesController do
  describe "routing" do

    it "routes to #index" do
      get("/http/path_rules").should route_to("http/path_rules#index")
    end

    it "routes to #new" do
      get("/http/path_rules/new").should route_to("http/path_rules#new")
    end

    it "routes to #show" do
      get("/http/path_rules/1").should route_to("http/path_rules#show", :id => "1")
    end

    it "routes to #edit" do
      get("/http/path_rules/1/edit").should route_to("http/path_rules#edit", :id => "1")
    end

    it "routes to #create" do
      post("/http/path_rules").should route_to("http/path_rules#create")
    end

    it "routes to #update" do
      put("/http/path_rules/1").should route_to("http/path_rules#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/http/path_rules/1").should route_to("http/path_rules#destroy", :id => "1")
    end

  end
end

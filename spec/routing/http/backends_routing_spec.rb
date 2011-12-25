require "spec_helper"

describe Http::BackendsController do
  describe "routing" do

    it "routes to #index" do
      get("/http/backends").should route_to("http/backends#index")
    end

    it "routes to #new" do
      get("/http/backends/new").should route_to("http/backends#new")
    end

    it "routes to #show" do
      get("/http/backends/1").should route_to("http/backends#show", :id => "1")
    end

    it "routes to #edit" do
      get("/http/backends/1/edit").should route_to("http/backends#edit", :id => "1")
    end

    it "routes to #create" do
      post("/http/backends").should route_to("http/backends#create")
    end

    it "routes to #update" do
      put("/http/backends/1").should route_to("http/backends#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/http/backends/1").should route_to("http/backends#destroy", :id => "1")
    end

  end
end

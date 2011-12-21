require "spec_helper"

describe Http::BackendsController do
  describe "routing" do

    it "routes to #index" do
      get("/http_backends").should route_to("http_backends#index")
    end

    it "routes to #new" do
      get("/http_backends/new").should route_to("http_backends#new")
    end

    it "routes to #show" do
      get("/http_backends/1").should route_to("http_backends#show", :id => "1")
    end

    it "routes to #edit" do
      get("/http_backends/1/edit").should route_to("http_backends#edit", :id => "1")
    end

    it "routes to #create" do
      post("/http_backends").should route_to("http_backends#create")
    end

    it "routes to #update" do
      put("/http_backends/1").should route_to("http_backends#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/http_backends/1").should route_to("http_backends#destroy", :id => "1")
    end

  end
end

require "spec_helper"

describe Core::ReleasesController do
  describe "routing" do

    it "routes to #index" do
      get("/core_releases").should route_to("core_releases#index")
    end

    it "routes to #new" do
      get("/core_releases/new").should route_to("core_releases#new")
    end

    it "routes to #show" do
      get("/core_releases/1").should route_to("core_releases#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core_releases/1/edit").should route_to("core_releases#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core_releases").should route_to("core_releases#create")
    end

    it "routes to #update" do
      put("/core_releases/1").should route_to("core_releases#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core_releases/1").should route_to("core_releases#destroy", :id => "1")
    end

  end
end

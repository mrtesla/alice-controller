require "spec_helper"

describe Core::ApplicationsController do
  describe "routing" do

    it "routes to #index" do
      get("/core/applications").should route_to("core/applications#index")
    end

    it "routes to #new" do
      get("/core/applications/new").should route_to("core/applications#new")
    end

    it "routes to #show" do
      get("/core/applications/1").should route_to("core/applications#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/applications/1/edit").should route_to("core/applications#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/applications").should route_to("core/applications#create")
    end

    it "routes to #update" do
      put("/core/applications/1").should route_to("core/applications#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/applications/1").should route_to("core/applications#destroy", :id => "1")
    end

  end
end

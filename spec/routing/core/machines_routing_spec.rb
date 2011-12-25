require "spec_helper"

describe Core::MachinesController do
  describe "routing" do

    it "routes to #index" do
      get("/core/machines").should route_to("core/machines#index")
    end

    it "routes to #new" do
      get("/core/machines/new").should route_to("core/machines#new")
    end

    it "routes to #show" do
      get("/core/machines/1").should route_to("core/machines#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/machines/1/edit").should route_to("core/machines#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/machines").should route_to("core/machines#create")
    end

    it "routes to #update" do
      put("/core/machines/1").should route_to("core/machines#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/machines/1").should route_to("core/machines#destroy", :id => "1")
    end

  end
end

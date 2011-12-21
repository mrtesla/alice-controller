require "spec_helper"

describe Core::MachinesController do
  describe "routing" do

    it "routes to #index" do
      get("/core_machines").should route_to("core_machines#index")
    end

    it "routes to #new" do
      get("/core_machines/new").should route_to("core_machines#new")
    end

    it "routes to #show" do
      get("/core_machines/1").should route_to("core_machines#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core_machines/1/edit").should route_to("core_machines#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core_machines").should route_to("core_machines#create")
    end

    it "routes to #update" do
      put("/core_machines/1").should route_to("core_machines#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core_machines/1").should route_to("core_machines#destroy", :id => "1")
    end

  end
end

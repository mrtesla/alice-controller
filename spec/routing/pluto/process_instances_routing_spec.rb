require "spec_helper"

describe Pluto::ProcessInstancesController do
  describe "routing" do

    it "routes to #index" do
      get("/pluto_process_instances").should route_to("pluto_process_instances#index")
    end

    it "routes to #new" do
      get("/pluto_process_instances/new").should route_to("pluto_process_instances#new")
    end

    it "routes to #show" do
      get("/pluto_process_instances/1").should route_to("pluto_process_instances#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pluto_process_instances/1/edit").should route_to("pluto_process_instances#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pluto_process_instances").should route_to("pluto_process_instances#create")
    end

    it "routes to #update" do
      put("/pluto_process_instances/1").should route_to("pluto_process_instances#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pluto_process_instances/1").should route_to("pluto_process_instances#destroy", :id => "1")
    end

  end
end

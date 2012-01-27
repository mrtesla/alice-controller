require "spec_helper"

describe Pluto::ProcessDefinitionsController do
  describe "routing" do

    it "routes to #index" do
      get("/pluto_process_definitions").should route_to("pluto_process_definitions#index")
    end

    it "routes to #new" do
      get("/pluto_process_definitions/new").should route_to("pluto_process_definitions#new")
    end

    it "routes to #show" do
      get("/pluto_process_definitions/1").should route_to("pluto_process_definitions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pluto_process_definitions/1/edit").should route_to("pluto_process_definitions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pluto_process_definitions").should route_to("pluto_process_definitions#create")
    end

    it "routes to #update" do
      put("/pluto_process_definitions/1").should route_to("pluto_process_definitions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pluto_process_definitions/1").should route_to("pluto_process_definitions#destroy", :id => "1")
    end

  end
end

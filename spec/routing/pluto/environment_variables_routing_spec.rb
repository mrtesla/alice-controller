require "spec_helper"

describe Pluto::EnvironmentVariablesController do
  describe "routing" do

    it "routes to #index" do
      get("/pluto_environment_variables").should route_to("pluto_environment_variables#index")
    end

    it "routes to #new" do
      get("/pluto_environment_variables/new").should route_to("pluto_environment_variables#new")
    end

    it "routes to #show" do
      get("/pluto_environment_variables/1").should route_to("pluto_environment_variables#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pluto_environment_variables/1/edit").should route_to("pluto_environment_variables#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pluto_environment_variables").should route_to("pluto_environment_variables#create")
    end

    it "routes to #update" do
      put("/pluto_environment_variables/1").should route_to("pluto_environment_variables#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pluto_environment_variables/1").should route_to("pluto_environment_variables#destroy", :id => "1")
    end

  end
end

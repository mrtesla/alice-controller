require "spec_helper"

describe Http::PassersController do
  describe "routing" do

    it "routes to #index" do
      get("/http_passers").should route_to("http_passers#index")
    end

    it "routes to #new" do
      get("/http_passers/new").should route_to("http_passers#new")
    end

    it "routes to #show" do
      get("/http_passers/1").should route_to("http_passers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/http_passers/1/edit").should route_to("http_passers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/http_passers").should route_to("http_passers#create")
    end

    it "routes to #update" do
      put("/http_passers/1").should route_to("http_passers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/http_passers/1").should route_to("http_passers#destroy", :id => "1")
    end

  end
end

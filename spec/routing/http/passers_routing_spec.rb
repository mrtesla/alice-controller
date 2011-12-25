require "spec_helper"

describe Http::PassersController do
  describe "routing" do

    it "routes to #index" do
      get("/http/passers").should route_to("http/passers#index")
    end

    it "routes to #new" do
      get("/http/passers/new").should route_to("http/passers#new")
    end

    it "routes to #show" do
      get("/http/passers/1").should route_to("http/passers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/http/passers/1/edit").should route_to("http/passers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/http/passers").should route_to("http/passers#create")
    end

    it "routes to #update" do
      put("/http/passers/1").should route_to("http/passers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/http/passers/1").should route_to("http/passers#destroy", :id => "1")
    end

  end
end

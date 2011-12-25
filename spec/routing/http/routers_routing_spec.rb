require "spec_helper"

describe Http::RoutersController do
  describe "routing" do

    it "routes to #index" do
      get("/http/routers").should route_to("http/routers#index")
    end

    it "routes to #new" do
      get("/http/routers/new").should route_to("http/routers#new")
    end

    it "routes to #show" do
      get("/http/routers/1").should route_to("http/routers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/http/routers/1/edit").should route_to("http/routers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/http/routers").should route_to("http/routers#create")
    end

    it "routes to #update" do
      put("/http/routers/1").should route_to("http/routers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/http/routers/1").should route_to("http/routers#destroy", :id => "1")
    end

  end
end

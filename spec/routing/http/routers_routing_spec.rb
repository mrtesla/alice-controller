require "spec_helper"

describe Http::RoutersController do
  describe "routing" do

    it "routes to #index" do
      get("/http_routers").should route_to("http_routers#index")
    end

    it "routes to #new" do
      get("/http_routers/new").should route_to("http_routers#new")
    end

    it "routes to #show" do
      get("/http_routers/1").should route_to("http_routers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/http_routers/1/edit").should route_to("http_routers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/http_routers").should route_to("http_routers#create")
    end

    it "routes to #update" do
      put("/http_routers/1").should route_to("http_routers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/http_routers/1").should route_to("http_routers#destroy", :id => "1")
    end

  end
end

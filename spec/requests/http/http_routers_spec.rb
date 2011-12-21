require 'spec_helper'

describe "Http::Routers" do
  describe "GET /http_routers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get http_routers_path
      response.status.should be(200)
    end
  end
end

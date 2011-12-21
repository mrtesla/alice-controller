require 'spec_helper'

describe "Core::Machines" do
  describe "GET /core_machines" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get core_machines_path
      response.status.should be(200)
    end
  end
end

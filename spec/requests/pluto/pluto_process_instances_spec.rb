require 'spec_helper'

describe "Pluto::ProcessInstances" do
  describe "GET /pluto_process_instances" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get pluto_process_instances_path
      response.status.should be(200)
    end
  end
end

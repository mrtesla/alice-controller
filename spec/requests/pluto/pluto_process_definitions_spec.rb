require 'spec_helper'

describe "Pluto::ProcessDefinitions" do
  describe "GET /pluto_process_definitions" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get pluto_process_definitions_path
      response.status.should be(200)
    end
  end
end

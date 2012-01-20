require 'spec_helper'

describe "Pluto::EnvironmentVariables" do
  describe "GET /pluto_environment_variables" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get pluto_environment_variables_path
      response.status.should be(200)
    end
  end
end

require 'spec_helper'

describe "pluto_environment_variables/show.html.erb" do
  before(:each) do
    @environment_variable = assign(:environment_variable, stub_model(Pluto::EnvironmentVariable,
      :owner_id => 1,
      :owner_type => "Owner Type",
      :name => "Name",
      :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Owner Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Value/)
  end
end

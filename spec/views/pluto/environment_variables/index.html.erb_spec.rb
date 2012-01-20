require 'spec_helper'

describe "pluto_environment_variables/index.html.erb" do
  before(:each) do
    assign(:pluto_environment_variables, [
      stub_model(Pluto::EnvironmentVariable,
        :owner_id => 1,
        :owner_type => "Owner Type",
        :name => "Name",
        :value => "Value"
      ),
      stub_model(Pluto::EnvironmentVariable,
        :owner_id => 1,
        :owner_type => "Owner Type",
        :name => "Name",
        :value => "Value"
      )
    ])
  end

  it "renders a list of pluto_environment_variables" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Owner Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end

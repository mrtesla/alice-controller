require 'spec_helper'

describe "pluto_process_definitions/index" do
  before(:each) do
    assign(:pluto_process_definitions, [
      stub_model(Pluto::ProcessDefinition,
        :owner_id => 1,
        :owner_type => "Owner Type",
        :name => "Name",
        :concurrency => 1,
        :command => "Command"
      ),
      stub_model(Pluto::ProcessDefinition,
        :owner_id => 1,
        :owner_type => "Owner Type",
        :name => "Name",
        :concurrency => 1,
        :command => "Command"
      )
    ])
  end

  it "renders a list of pluto_process_definitions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Owner Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Command".to_s, :count => 2
  end
end

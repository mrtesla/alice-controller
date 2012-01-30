require 'spec_helper'

describe "pluto_process_instances/index" do
  before(:each) do
    assign(:pluto_process_instances, [
      stub_model(Pluto::ProcessInstance,
        :pluto_process_definition_id => 1,
        :core_machine_id => 1,
        :instance => 1,
        :state => "State",
        :requested_state => "Requested State"
      ),
      stub_model(Pluto::ProcessInstance,
        :pluto_process_definition_id => 1,
        :core_machine_id => 1,
        :instance => 1,
        :state => "State",
        :requested_state => "Requested State"
      )
    ])
  end

  it "renders a list of pluto_process_instances" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "State".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Requested State".to_s, :count => 2
  end
end

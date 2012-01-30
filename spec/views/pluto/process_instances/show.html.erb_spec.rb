require 'spec_helper'

describe "pluto_process_instances/show" do
  before(:each) do
    @process_instance = assign(:process_instance, stub_model(Pluto::ProcessInstance,
      :pluto_process_definition_id => 1,
      :core_machine_id => 1,
      :instance => 1,
      :state => "State",
      :requested_state => "Requested State"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/State/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Requested State/)
  end
end

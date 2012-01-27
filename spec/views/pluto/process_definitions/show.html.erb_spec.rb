require 'spec_helper'

describe "pluto_process_definitions/show" do
  before(:each) do
    @process_definition = assign(:process_definition, stub_model(Pluto::ProcessDefinition,
      :owner_id => 1,
      :owner_type => "Owner Type",
      :name => "Name",
      :concurrency => 1,
      :command => "Command"
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
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Command/)
  end
end

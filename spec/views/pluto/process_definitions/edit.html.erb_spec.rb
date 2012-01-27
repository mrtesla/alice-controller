require 'spec_helper'

describe "pluto_process_definitions/edit" do
  before(:each) do
    @process_definition = assign(:process_definition, stub_model(Pluto::ProcessDefinition,
      :owner_id => 1,
      :owner_type => "MyString",
      :name => "MyString",
      :concurrency => 1,
      :command => "MyString"
    ))
  end

  it "renders the edit process_definition form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pluto_process_definitions_path(@process_definition), :method => "post" do
      assert_select "input#process_definition_owner_id", :name => "process_definition[owner_id]"
      assert_select "input#process_definition_owner_type", :name => "process_definition[owner_type]"
      assert_select "input#process_definition_name", :name => "process_definition[name]"
      assert_select "input#process_definition_concurrency", :name => "process_definition[concurrency]"
      assert_select "input#process_definition_command", :name => "process_definition[command]"
    end
  end
end

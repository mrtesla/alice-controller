require 'spec_helper'

describe "pluto_process_instances/edit" do
  before(:each) do
    @process_instance = assign(:process_instance, stub_model(Pluto::ProcessInstance,
      :pluto_process_defintion_id => 1,
      :core_machine_id => 1,
      :instance => 1,
      :state => "MyString",
      :requested_state => "MyString"
    ))
  end

  it "renders the edit process_instance form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pluto_process_instances_path(@process_instance), :method => "post" do
      assert_select "input#process_instance_pluto_process_defintion_id", :name => "process_instance[pluto_process_defintion_id]"
      assert_select "input#process_instance_core_machine_id", :name => "process_instance[core_machine_id]"
      assert_select "input#process_instance_instance", :name => "process_instance[instance]"
      assert_select "input#process_instance_state", :name => "process_instance[state]"
      assert_select "input#process_instance_requested_state", :name => "process_instance[requested_state]"
    end
  end
end

require 'spec_helper'

describe "core_machines/edit.html.erb" do
  before(:each) do
    @machine = assign(:machine, stub_model(Core::Machine,
      :host => "MyString"
    ))
  end

  it "renders the edit machine form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => core_machines_path(@machine), :method => "post" do
      assert_select "input#machine_host", :name => "machine[host]"
    end
  end
end

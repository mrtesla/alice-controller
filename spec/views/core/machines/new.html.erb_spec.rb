require 'spec_helper'

describe "core_machines/new.html.erb" do
  before(:each) do
    assign(:machine, stub_model(Core::Machine,
      :host => "MyString"
    ).as_new_record)
  end

  it "renders new machine form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => core_machines_path, :method => "post" do
      assert_select "input#machine_host", :name => "machine[host]"
    end
  end
end

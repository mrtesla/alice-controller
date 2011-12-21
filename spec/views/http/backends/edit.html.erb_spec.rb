require 'spec_helper'

describe "http_backends/edit.html.erb" do
  before(:each) do
    @backend = assign(:backend, stub_model(Http::Backend,
      :core_machine_id => 1,
      :core_application_id => 1,
      :process => "MyString",
      :instance => 1,
      :port => 1
    ))
  end

  it "renders the edit backend form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => http_backends_path(@backend), :method => "post" do
      assert_select "input#backend_core_machine_id", :name => "backend[core_machine_id]"
      assert_select "input#backend_core_application_id", :name => "backend[core_application_id]"
      assert_select "input#backend_process", :name => "backend[process]"
      assert_select "input#backend_instance", :name => "backend[instance]"
      assert_select "input#backend_port", :name => "backend[port]"
    end
  end
end

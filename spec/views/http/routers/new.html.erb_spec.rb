require 'spec_helper'

describe "http_routers/new.html.erb" do
  before(:each) do
    assign(:router, stub_model(Http::Router,
      :core_machine_id => 1,
      :port => 1
    ).as_new_record)
  end

  it "renders new router form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => http_routers_path, :method => "post" do
      assert_select "input#router_core_machine_id", :name => "router[core_machine_id]"
      assert_select "input#router_port", :name => "router[port]"
    end
  end
end

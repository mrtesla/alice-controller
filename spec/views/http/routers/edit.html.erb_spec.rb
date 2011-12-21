require 'spec_helper'

describe "http_routers/edit.html.erb" do
  before(:each) do
    @router = assign(:router, stub_model(Http::Router,
      :core_machine_id => 1,
      :port => 1
    ))
  end

  it "renders the edit router form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => http_routers_path(@router), :method => "post" do
      assert_select "input#router_core_machine_id", :name => "router[core_machine_id]"
      assert_select "input#router_port", :name => "router[port]"
    end
  end
end

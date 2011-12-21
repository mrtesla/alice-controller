require 'spec_helper'

describe "http_backends/index.html.erb" do
  before(:each) do
    assign(:http_backends, [
      stub_model(Http::Backend,
        :core_machine_id => 1,
        :core_application_id => 1,
        :process => "Process",
        :instance => 1,
        :port => 1
      ),
      stub_model(Http::Backend,
        :core_machine_id => 1,
        :core_application_id => 1,
        :process => "Process",
        :instance => 1,
        :port => 1
      )
    ])
  end

  it "renders a list of http_backends" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Process".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end

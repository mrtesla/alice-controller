require 'spec_helper'

describe "http_path_rules/index.html.erb" do
  before(:each) do
    assign(:http_path_rules, [
      stub_model(Http::PathRule,
        :core_application_id => 1,
        :path => "Path",
        :actions => "MyText"
      ),
      stub_model(Http::PathRule,
        :core_application_id => 1,
        :path => "Path",
        :actions => "MyText"
      )
    ])
  end

  it "renders a list of http_path_rules" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Path".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end

require 'spec_helper'

describe "http_domain_rules/index.html.erb" do
  before(:each) do
    assign(:http_domain_rules, [
      stub_model(Http::DomainRule,
        :core_application_id => 1,
        :domain => "Domain",
        :actions => "MyText"
      ),
      stub_model(Http::DomainRule,
        :core_application_id => 1,
        :domain => "Domain",
        :actions => "MyText"
      )
    ])
  end

  it "renders a list of http_domain_rules" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Domain".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end

require 'spec_helper'

describe "http_domain_rules/show.html.erb" do
  before(:each) do
    @domain_rule = assign(:domain_rule, stub_model(Http::DomainRule,
      :core_application_id => 1,
      :domain => "Domain",
      :actions => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Domain/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end

require 'spec_helper'

describe "http_domain_rules/edit.html.erb" do
  before(:each) do
    @domain_rule = assign(:domain_rule, stub_model(Http::DomainRule,
      :core_application_id => 1,
      :domain => "MyString",
      :actions => "MyText"
    ))
  end

  it "renders the edit domain_rule form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => http_domain_rules_path(@domain_rule), :method => "post" do
      assert_select "input#domain_rule_core_application_id", :name => "domain_rule[core_application_id]"
      assert_select "input#domain_rule_domain", :name => "domain_rule[domain]"
      assert_select "textarea#domain_rule_actions", :name => "domain_rule[actions]"
    end
  end
end

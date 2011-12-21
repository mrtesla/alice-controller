require 'spec_helper'

describe "http_path_rules/new.html.erb" do
  before(:each) do
    assign(:path_rule, stub_model(Http::PathRule,
      :core_application_id => 1,
      :path => "MyString",
      :actions => "MyText"
    ).as_new_record)
  end

  it "renders new path_rule form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => http_path_rules_path, :method => "post" do
      assert_select "input#path_rule_core_application_id", :name => "path_rule[core_application_id]"
      assert_select "input#path_rule_path", :name => "path_rule[path]"
      assert_select "textarea#path_rule_actions", :name => "path_rule[actions]"
    end
  end
end

require 'spec_helper'

describe "http_path_rules/show.html.erb" do
  before(:each) do
    @path_rule = assign(:path_rule, stub_model(Http::PathRule,
      :core_application_id => 1,
      :path => "Path",
      :actions => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Path/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end

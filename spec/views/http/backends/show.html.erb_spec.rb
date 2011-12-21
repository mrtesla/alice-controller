require 'spec_helper'

describe "http_backends/show.html.erb" do
  before(:each) do
    @backend = assign(:backend, stub_model(Http::Backend,
      :core_machine_id => 1,
      :core_application_id => 1,
      :process => "Process",
      :instance => 1,
      :port => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Process/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end

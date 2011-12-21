require 'spec_helper'

describe "http_routers/show.html.erb" do
  before(:each) do
    @router = assign(:router, stub_model(Http::Router,
      :core_machine_id => 1,
      :port => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end

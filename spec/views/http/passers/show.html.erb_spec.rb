require 'spec_helper'

describe "http_passers/show.html.erb" do
  before(:each) do
    @passer = assign(:passer, stub_model(Http::Passer,
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

require 'spec_helper'

describe "core_applications/show.html.erb" do
  before(:each) do
    @application = assign(:core_application, stub_model(Core::Application,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end

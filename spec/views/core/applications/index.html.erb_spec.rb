require 'spec_helper'

describe "core_applications/index.html.erb" do
  before(:each) do
    assign(:core_applications, [
      stub_model(Core::Application,
        :name => "Name"
      ),
      stub_model(Core::Application,
        :name => "Name"
      )
    ])
  end

  it "renders a list of core_applications" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end

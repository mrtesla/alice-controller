require 'spec_helper'

describe "core_machines/index.html.erb" do
  before(:each) do
    assign(:core_machines, [
      stub_model(Core::Machine,
        :host => "Host"
      ),
      stub_model(Core::Machine,
        :host => "Host"
      )
    ])
  end

  it "renders a list of core_machines" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Host".to_s, :count => 2
  end
end

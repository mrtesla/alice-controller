require 'spec_helper'

describe "core_releases/index.html.erb" do
  before(:each) do
    assign(:core_releases, [
      stub_model(Core::Release,
        :application_id => 1,
        :number => 1,
        :activated => false
      ),
      stub_model(Core::Release,
        :application_id => 1,
        :number => 1,
        :activated => false
      )
    ])
  end

  it "renders a list of core_releases" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end

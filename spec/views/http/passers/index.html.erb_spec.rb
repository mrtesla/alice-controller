require 'spec_helper'

describe "http_passers/index.html.erb" do
  before(:each) do
    assign(:http_passers, [
      stub_model(Http::Passer,
        :core_machine_id => 1,
        :port => 1
      ),
      stub_model(Http::Passer,
        :core_machine_id => 1,
        :port => 1
      )
    ])
  end

  it "renders a list of http_passers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end

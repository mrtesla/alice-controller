require 'spec_helper'

describe "http_passers/edit.html.erb" do
  before(:each) do
    @passer = assign(:passer, stub_model(Http::Passer,
      :core_machine_id => 1,
      :port => 1
    ))
  end

  it "renders the edit passer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => http_passers_path(@passer), :method => "post" do
      assert_select "input#passer_core_machine_id", :name => "passer[core_machine_id]"
      assert_select "input#passer_port", :name => "passer[port]"
    end
  end
end

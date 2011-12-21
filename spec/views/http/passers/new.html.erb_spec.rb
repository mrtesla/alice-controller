require 'spec_helper'

describe "http_passers/new.html.erb" do
  before(:each) do
    assign(:passer, stub_model(Http::Passer,
      :core_machine_id => 1,
      :port => 1
    ).as_new_record)
  end

  it "renders new passer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => http_passers_path, :method => "post" do
      assert_select "input#passer_core_machine_id", :name => "passer[core_machine_id]"
      assert_select "input#passer_port", :name => "passer[port]"
    end
  end
end

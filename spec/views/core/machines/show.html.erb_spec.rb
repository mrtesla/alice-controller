require 'spec_helper'

describe "core_machines/show.html.erb" do
  before(:each) do
    @machine = assign(:machine, stub_model(Core::Machine,
      :host => "Host"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Host/)
  end
end

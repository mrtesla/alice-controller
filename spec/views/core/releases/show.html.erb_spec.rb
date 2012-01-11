require 'spec_helper'

describe "core_releases/show.html.erb" do
  before(:each) do
    @release = assign(:release, stub_model(Core::Release,
      :application_id => 1,
      :number => 1,
      :activated => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end

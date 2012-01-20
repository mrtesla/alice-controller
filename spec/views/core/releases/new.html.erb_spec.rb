require 'spec_helper'

describe "core_releases/new.html.erb" do
  before(:each) do
    assign(:release, stub_model(Core::Release,
      :application_id => 1,
      :number => 1,
      :activated => false
    ).as_new_record)
  end

  it "renders new release form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => core_releases_path, :method => "post" do
      assert_select "input#release_application_id", :name => "release[application_id]"
      assert_select "input#release_number", :name => "release[number]"
      assert_select "input#release_activated", :name => "release[activated]"
    end
  end
end

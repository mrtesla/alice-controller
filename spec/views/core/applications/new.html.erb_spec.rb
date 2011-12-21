require 'spec_helper'

describe "core_applications/new.html.erb" do
  before(:each) do
    assign(:core_application, stub_model(Core::Application,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new application form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => core_applications_path, :method => "post" do
      assert_select "input#core_application_name", :name => "core_application[name]"
    end
  end
end

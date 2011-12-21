require 'spec_helper'

describe "core_applications/edit.html.erb" do
  before(:each) do
    @application = assign(:core_application, stub_model(Core::Application,
      :name => "MyString"
    ))
  end

  it "renders the edit application form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => core_applications_path(@application), :method => "post" do
      assert_select "input#core_application_name", :name => "core_application[name]"
    end
  end
end

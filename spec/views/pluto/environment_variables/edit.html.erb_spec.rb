require 'spec_helper'

describe "pluto_environment_variables/edit.html.erb" do
  before(:each) do
    @environment_variable = assign(:environment_variable, stub_model(Pluto::EnvironmentVariable,
      :owner_id => 1,
      :owner_type => "MyString",
      :name => "MyString",
      :value => "MyString"
    ))
  end

  it "renders the edit environment_variable form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pluto_environment_variables_path(@environment_variable), :method => "post" do
      assert_select "input#environment_variable_owner_id", :name => "environment_variable[owner_id]"
      assert_select "input#environment_variable_owner_type", :name => "environment_variable[owner_type]"
      assert_select "input#environment_variable_name", :name => "environment_variable[name]"
      assert_select "input#environment_variable_value", :name => "environment_variable[value]"
    end
  end
end

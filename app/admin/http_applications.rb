ActiveAdmin.register Http::Application do
  menu :parent => "Http"

#  show do
#    panel "Rath rules" do
#      table_for(application.path_rules) do
#        column("Pattern", :sortable => :id) {|rule| link_to rule.path, path_rule_path(rule) }
#        column("Actions")                   {|rule| rule.actions }
#      end
#    end
#    active_admin_comments
#  end
end

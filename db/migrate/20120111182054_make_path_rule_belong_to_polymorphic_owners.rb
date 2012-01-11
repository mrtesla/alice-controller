class MakePathRuleBelongToPolymorphicOwners < ActiveRecord::Migration
  def up
    change_table :http_path_rules do |t|
      t.rename :core_application_id, :owner_id
      t.string :owner_type
    end
    execute "UPDATE http_path_rules SET owner_type = 'Core::Application'"
  end

  def down
    change_table :http_path_rules do |t|
      t.rename :owner_id, :core_application_id
      t.remove :owner_type
    end
  end
end

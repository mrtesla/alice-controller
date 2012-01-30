class FixTypoInPlutoProcessInstancesTable < ActiveRecord::Migration
  def change
    change_table :pluto_process_instances do |t|
      t.rename :pluto_process_defintion_id, :pluto_process_definition_id
    end
  end
end

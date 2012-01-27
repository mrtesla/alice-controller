class CreatePlutoProcessInstances < ActiveRecord::Migration
  def change
    create_table :pluto_process_instances do |t|
      t.integer :pluto_process_defintion_id
      t.integer :core_machine_id
      t.integer :instance
      t.datetime :running_since
      t.datetime :down_since
      t.string :state
      t.datetime :last_seen_at
      t.string :requested_state

      t.timestamps
    end
  end
end

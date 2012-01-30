class AddJoinTableBetweenCoreMachinesAndCoreReleases < ActiveRecord::Migration
  def change
    create_table :core_machines_core_releases, id: false do |t|
      t.integer :core_machine_id
      t.integer :core_release_id
    end
  end
end

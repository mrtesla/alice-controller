class ImprovePlutoProcessInstanceSchema < ActiveRecord::Migration
  def change
    change_table :pluto_process_instances do |t|
      t.remove :requested_state
      t.remove :state
    end
  end
end

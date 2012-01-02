class AddMaintenanceModeToCoreApplications < ActiveRecord::Migration
  def change
    change_table :core_applications do |t|
      t.boolean :maintenance_mode, default: false
    end
  end
end

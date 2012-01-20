class AddSuspendedModeToApplications < ActiveRecord::Migration
  def change
    change_table :core_applications do |t|
      t.boolean :suspended_mode, default: false
    end
  end
end

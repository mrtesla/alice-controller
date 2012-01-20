class AddActiveCoreReleaseIdToCoreApplications < ActiveRecord::Migration
  def change
    change_table :core_applications do |t|
      t.integer :active_core_release_id
    end
  end
end

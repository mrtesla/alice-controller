class CreateCoreApplications < ActiveRecord::Migration
  def change
    create_table :core_applications do |t|
      t.string :name

      t.timestamps
    end
  end
end

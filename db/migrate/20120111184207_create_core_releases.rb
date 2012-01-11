class CreateCoreReleases < ActiveRecord::Migration
  def change
    create_table :core_releases do |t|
      t.integer :application_id
      t.integer :number

      t.timestamps
    end
  end
end

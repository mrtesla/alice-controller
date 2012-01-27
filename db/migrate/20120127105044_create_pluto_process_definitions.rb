class CreatePlutoProcessDefinitions < ActiveRecord::Migration
  def change
    create_table :pluto_process_definitions do |t|
      t.integer :owner_id
      t.string :owner_type
      t.string :name
      t.integer :concurrency, default: 1
      t.string :command

      t.timestamps
    end
  end
end

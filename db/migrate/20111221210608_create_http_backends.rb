class CreateHttpBackends < ActiveRecord::Migration
  def change
    create_table :http_backends do |t|
      t.integer :core_machine_id
      t.integer :core_application_id
      t.string :process
      t.integer :instance
      t.integer :port
      t.datetime :last_seen_at

      t.timestamps
    end
  end
end

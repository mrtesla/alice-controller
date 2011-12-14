class CreateHttpBackends < ActiveRecord::Migration
  def change
    create_table :http_backends do |t|
      t.integer :machine_id
      t.integer :application_id
      t.string  :process
      t.integer :port

      t.timestamps
    end
  end
end

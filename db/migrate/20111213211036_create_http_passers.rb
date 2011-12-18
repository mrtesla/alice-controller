class CreateHttpPassers < ActiveRecord::Migration
  def change
    create_table :http_passers do |t|
      t.integer :core_machine_id
      t.integer :port

      t.timestamps
    end
  end
end

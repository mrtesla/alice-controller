class CreateHttpRouters < ActiveRecord::Migration
  def change
    create_table :http_routers do |t|
      t.integer :core_machine_id
      t.integer :port

      t.timestamps
    end
  end
end

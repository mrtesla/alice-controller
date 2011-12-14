class CreateHttpMachines < ActiveRecord::Migration
  def change
    create_table :http_machines do |t|
      t.string :host

      t.timestamps
    end
  end
end

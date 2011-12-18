class CreateCoreMachines < ActiveRecord::Migration
  def change
    create_table :core_machines do |t|
      t.string :host

      t.timestamps
    end
  end
end

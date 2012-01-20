class CreatePlutoEnvironmentVariables < ActiveRecord::Migration
  def change
    create_table :pluto_environment_variables do |t|
      t.integer :owner_id
      t.string :owner_type
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end

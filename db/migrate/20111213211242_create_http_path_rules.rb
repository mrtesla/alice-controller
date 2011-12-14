class CreateHttpPathRules < ActiveRecord::Migration
  def change
    create_table :http_path_rules do |t|
      t.integer :application_id
      t.string :path
      t.text :actions

      t.timestamps
    end
  end
end

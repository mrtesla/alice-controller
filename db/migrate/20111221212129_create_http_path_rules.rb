class CreateHttpPathRules < ActiveRecord::Migration
  def change
    create_table :http_path_rules do |t|
      t.integer :core_application_id
      t.string :path
      t.text :actions, default: '[]'

      t.timestamps
    end
  end
end

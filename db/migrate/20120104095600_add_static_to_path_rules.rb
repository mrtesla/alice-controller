class AddStaticToPathRules < ActiveRecord::Migration
  def change
    change_table :http_path_rules do |t|
      t.boolean :static, default: false
    end
  end
end

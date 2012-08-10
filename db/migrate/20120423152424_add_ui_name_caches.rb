class AddUiNameCaches < ActiveRecord::Migration
  def up
    change_table :http_routers do |t|
      t.string :ui_name
    end
    change_table :http_passers do |t|
      t.string :ui_name
    end
    change_table :http_backends do |t|
      t.string :ui_name
    end
  end

  def down
    change_table :http_routers do |t|
      t.remove :ui_name
    end
    change_table :http_passers do |t|
      t.remove :ui_name
    end
    change_table :http_backends do |t|
      t.remove :ui_name
    end
  end
end

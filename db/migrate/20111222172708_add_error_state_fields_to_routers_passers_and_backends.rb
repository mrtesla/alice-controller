class AddErrorStateFieldsToRoutersPassersAndBackends < ActiveRecord::Migration
  def change
    change_table :http_routers do |t|
      t.datetime :down_since
      t.string   :error_message
    end
    change_table :http_passers do |t|
      t.datetime :down_since
      t.string   :error_message
    end
    change_table :http_backends do |t|
      t.datetime :down_since
      t.string   :error_message
    end
  end
end

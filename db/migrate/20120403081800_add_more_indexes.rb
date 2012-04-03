class AddMoreIndexes < ActiveRecord::Migration
  def change
    change_table :core_applications do |t|
      t.index [:name]
    end

    change_table :http_routers do |t|
      t.index [:port]
      t.index [:down_since]
    end

    change_table :http_passers do |t|
      t.index [:port]
      t.index [:down_since]
    end

    change_table :http_backends do |t|
      t.index [:port]
      t.index [:down_since]
      t.index [:core_application_id, :process, :instance], :name => 'app_process_instance_idx'
    end
  end
end

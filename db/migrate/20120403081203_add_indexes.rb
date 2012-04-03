class AddIndexes < ActiveRecord::Migration
  def change
    change_table :http_backends do |t|
      t.index [:core_machine_id, :port]
    end

    change_table :http_passers do |t|
      t.index [:core_machine_id, :port]
    end

    change_table :http_routers do |t|
      t.index [:core_machine_id, :port]
    end
  end
end

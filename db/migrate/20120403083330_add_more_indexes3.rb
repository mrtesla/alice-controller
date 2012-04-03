class AddMoreIndexes3 < ActiveRecord::Migration
  def change
    change_table :http_routers do |t|
      t.index [:core_machine_id, :down_since, :port], :name => "machine_down_port"
      t.index [:down_since, :port],                   :name => "down_port"
    end

    change_table :http_path_rules do |t|
      t.index [:owner_id, :owner_type],       :name => "owner"
      t.index [:owner_id, :owner_type, :path],:name => "owner_path"
    end
  end

end

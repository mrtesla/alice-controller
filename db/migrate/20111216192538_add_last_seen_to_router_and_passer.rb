class AddLastSeenToRouterAndPasser < ActiveRecord::Migration
  def change
    change_table :http_routers do |t|
      t.datetime :last_seen_at
    end
    change_table :http_passers do |t|
      t.datetime :last_seen_at
    end
  end
end

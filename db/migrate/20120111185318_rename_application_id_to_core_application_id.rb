class RenameApplicationIdToCoreApplicationId < ActiveRecord::Migration
  def change
    change_table :core_releases do |t|
      t.rename :application_id, :core_application_id
    end
  end
end

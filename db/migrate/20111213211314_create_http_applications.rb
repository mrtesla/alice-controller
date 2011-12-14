class CreateHttpApplications < ActiveRecord::Migration
  def change
    create_table :http_applications do |t|
      t.string :name

      t.timestamps
    end
  end
end

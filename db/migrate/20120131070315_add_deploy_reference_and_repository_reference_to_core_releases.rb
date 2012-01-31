class AddDeployReferenceAndRepositoryReferenceToCoreReleases < ActiveRecord::Migration
  def change
    change_table :core_releases do |t|
      t.string :deploy_reference
      t.string :repository_reference
    end
  end
end

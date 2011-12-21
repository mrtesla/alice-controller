class CreateHttpDomainRules < ActiveRecord::Migration
  def change
    create_table :http_domain_rules do |t|
      t.integer :core_application_id
      t.string :domain
      t.text :actions

      t.timestamps
    end
  end
end

require 'chef/data_bag'
require 'chef/data_bag_item'
require 'chef/search/query'

module Alice::Chef

  C = ::Chef

  class ProcessUpdater

    def initialize(release)
      @release = release
    end

    def update
      application_key = Digest::SHA1.hexdigest(@release.core_application.name)

      definitions   = Pluto::ProcessDefinition.where(owner_type: 'Core::Release', owner_id: @release.id).all
      new_processes = Pluto::ProcessInstance.where(pluto_process_definition_id: definitions.map(&:id)).all
      new_processes = new_processes.index_by { |p| Digest::SHA1.hexdigest([application_key, p.ui_name].join('')) }

      query = C::Search::Query.new
      query.search('alice-processes', "application_key:#{application_key}") do |process|
        new_process = new_processes.delete(process['id'])

        if new_process
          new_process = new_process.as_json
          new_process.each do |key, value|
            process[key] = value
          end
          process.save
        else
          process.destroy
        end
      end

      new_processes.each do |process_key, new_process|
        machine     = new_process.core_machine
        new_process = new_process.as_json
        process = Chef::DataBagItem.new
        process.data_bag('alice-processes')
        process.raw_data = new_process.merge({
          "id"              => process_key,
          "node"            => machine.host,
          "application_key" => application_key,
          "legacy"          => true
        })
        process.save
      end
    end

  end
end

class ApiV1::EndpointsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout false

  def register
    ActiveRecord::Base.transaction do
      (params[:_json] || []).each do |endpoint|
        case endpoint[:type]

        when 'router'
          machine = Core::Machine.find_by_host(endpoint[:machine])
          port    = endpoint[:port].to_i
          router  = Http::Router.where(core_machine_id: machine.try(:id), port: port)
          router  = (router.first or router.build)
          router.last_seen_at = Time.now
          router.save!

        when 'passer'
          machine = Core::Machine.find_by_host(endpoint[:machine])
          port    = endpoint[:port].to_i
          passer  = Http::Passer.where(core_machine_id: machine.try(:id), port: port)
          passer  = (passer.first or passer.build)
          passer.last_seen_at = Time.now
          passer.save!

        when 'backend'
          machine     = Core::Machine.find_by_host(endpoint[:machine])
          applidation = Core::Application.find_by_name(endpoint[:applidation])
          process     = endpoint[:process]
          instance    = endpoint[:instance].to_i
          port        = endpoint[:port].to_i

          backend  = Http::Backend.where(
            core_machine_id:     machine.try(:id),
            core_application_id: applidation.try(:id),
            process:             process,
            instance:            instance
          )
          backend  = (backend.first or backend.build)
          backend.port         = port
          backend.last_seen_at = Time.now
          backend.save!

        else
          raise ActiveRecord::RecordNotFound

        end
      end
    end

    render :json => { :status => 'OK' }
  end

end

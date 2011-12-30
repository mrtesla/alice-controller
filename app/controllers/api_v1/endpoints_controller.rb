class ApiV1::EndpointsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout false

  def index
    endpoints = {}
    endpoints['routers'] = Http::Router.includes(:core_machine).all.map do |router|
      { id: router.id, host: router.core_machine.host, port: router.port }
    end
    endpoints['passers'] = Http::Passer.includes(:core_machine).all.map do |passer|
      { id: passer.id, host: passer.core_machine.host, port: passer.port }
    end
    endpoints['backends'] = Http::Backend.includes(:core_machine).all.map do |backend|
      { id: backend.id, host: backend.core_machine.host, port: backend.port }
    end
    render :json => endpoints
  end

  def routers
    endpoints = {}
    endpoints['routers'] = Http::Router.includes(:core_machine).where(down_since: nil).all.map do |router|
      host = router.core_machine.host
      host = '127.0.0.1' if host == 'localhost'
      { id: router.id, host: host, port: router.port }
    end
    render :json => endpoints
  end

  def probe_report
    (params[:routers] || []).each do |id, status|
      router = (Http::Router.find(id) rescue nil)

      next unless router

      if status === true
        router.last_seen_at  = Time.now
        router.down_since    = nil
        router.error_message = nil
      else
        router.down_since  ||= Time.now
        router.error_message = status[:error]
      end

      router.save
    end
    (params[:passers] || []).each do |id, status|
      passer = (Http::Passer.find(id) rescue nil)

      next unless passer

      if status === true
        passer.last_seen_at  = Time.now
        passer.down_since    = nil
        passer.error_message = nil
      else
        passer.down_since  ||= Time.now
        passer.error_message = status[:error]
      end

      passer.save
    end
    (params[:backends] || []).each do |id, status|
      backend = (Http::Backend.find(id) rescue nil)

      next unless backend

      if status === true
        backend.last_seen_at  = Time.now
        backend.down_since    = nil
        backend.error_message = nil
      else
        backend.down_since  ||= Time.now
        backend.error_message = status[:error]
      end

      backend.save
    end

    Http::Router.send_to_redis
    Http::Passer.send_to_redis
    Http::Backend.send_to_redis

    render :json => { :status => 'OK' }
  end

  def register
    router_id = nil

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
          router_id = router.id

        when 'passer'
          machine = Core::Machine.find_by_host(endpoint[:machine])
          port    = endpoint[:port].to_i
          passer  = Http::Passer.where(core_machine_id: machine.try(:id), port: port)
          passer  = (passer.first or passer.build)
          passer.last_seen_at = Time.now
          passer.save!

        when 'backend'
          machine     = Core::Machine.find_by_host(endpoint[:machine])
          applidation = Core::Application.find_by_name(endpoint[:application])
          process     = endpoint[:process]
          instance    = endpoint[:instance].to_i
          port        = endpoint[:port].to_i

          backend  = Http::Backend.where(
            core_application_id: applidation.try(:id),
            process:             process,
            instance:            instance
          )
          backend  = (backend.first or backend.build)
          backend.port         = port
          backend.core_machine = machine
          backend.last_seen_at = Time.now
          backend.save

        else
          raise ActiveRecord::RecordNotFound

        end
      end

      Http::Router.send_to_redis
      Http::Passer.send_to_redis
      Http::Backend.send_to_redis
    end

    if router_id
      response.headers['X-Alice-Router-Id'] = router_id.to_s
    end

    render :json => { :status => 'OK' }
  end

end

class ApiV1::MachinesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout false

  def routers
    machine = Core::Machine.where(host: params[:machine_host]).first

    unless machine
      render :json => { :status => 'FAIL' }, :status => 404
      return
    end

    endpoints = {}
    endpoints['routers'] = machine.http_routers.where(down_since: nil).all.map do |router|
      host = machine.host
      host = '127.0.0.1' if host == 'localhost'
      { id: router.id, host: host, port: router.port }
    end

    render :json => endpoints
  end

  def endpoints
    machine = Core::Machine.where(host: params[:machine_host]).first

    unless machine
      render :json => { :status => 'FAIL' }, :status => 404
      return
    end

    endpoints = {}
    endpoints['routers'] = machine.http_routers.all.map do |router|
      { id: router.id, host: machine.host, port: router.port }
    end
    endpoints['passers'] = machine.http_passers.all.map do |passer|
      { id: passer.id, host: machine.host, port: passer.port }
    end
    endpoints['backends'] = machine.http_backends.all.map do |backend|
      { id: backend.id, host: machine.host, port: backend.port }
    end

    render :json => endpoints
  end

  def probe_report
    machine = Core::Machine.where(host: params[:machine_host]).first

    unless machine
      render :json => { :status => 'FAIL' }, :status => 404
      return
    end

    routers  = machine.http_routers.index_by(&:id)
    passers  = machine.http_passers.index_by(&:id)
    backends = machine.http_backends.index_by(&:id)
    prefix   = "alice.http|prober.report"

    (params[:routers] || []).each do |id, status|
      router = routers[id.to_i]
      next unless router

      if status === true
        if router.down_since
          REDIS.multi do
            REDIS.sadd("#{prefix}|routers.up",         id.to_s)
            REDIS.srem("#{prefix}|routers.down",       id.to_s)
            REDIS.srem("#{prefix}|routers.still_down", id.to_s)
          end
        end

        router.last_seen_at  = Time.now
        router.down_since    = nil
        router.error_message = nil
      else
        if router.down_since
          REDIS.multi do
            REDIS.srem("#{prefix}|routers.up",         id.to_s)
            REDIS.sadd("#{prefix}|routers.still_down", id.to_s)
          end
        else
          REDIS.multi do
            REDIS.srem("#{prefix}|routers.up",         id.to_s)
            REDIS.sadd("#{prefix}|routers.down",       id.to_s)
          end
        end

        router.down_since  ||= Time.now
        router.error_message = status[:error]
      end

      router.save
    end

    (params[:passers] || []).each do |id, status|
      passer = (Http::Passer.find(id) rescue nil)

      next unless passer

      if status === true
        if passer.down_since
          REDIS.multi do
            REDIS.sadd("#{prefix}|passers.up",         id.to_s)
            REDIS.srem("#{prefix}|passers.down",       id.to_s)
            REDIS.srem("#{prefix}|passers.still_down", id.to_s)
          end
        end

        passer.last_seen_at  = Time.now
        passer.down_since    = nil
        passer.error_message = nil
      else
        if passer.down_since
          REDIS.multi do
            REDIS.srem("#{prefix}|passers.up",         id.to_s)
            REDIS.sadd("#{prefix}|passers.still_down", id.to_s)
          end
        else
          REDIS.multi do
            REDIS.srem("#{prefix}|passers.up",         id.to_s)
            REDIS.sadd("#{prefix}|passers.down",       id.to_s)
          end
        end

        passer.down_since  ||= Time.now
        passer.error_message = status[:error]
      end

      passer.save
    end

    (params[:backends] || []).each do |id, status|
      backend = (Http::Backend.find(id) rescue nil)

      next unless backend

      if status === true
        if backend.down_since
          REDIS.multi do
            REDIS.sadd("#{prefix}|backends.up",         id.to_s)
            REDIS.srem("#{prefix}|backends.down",       id.to_s)
            REDIS.srem("#{prefix}|backends.still_down", id.to_s)
          end
        end

        backend.last_seen_at  = Time.now
        backend.down_since    = nil
        backend.error_message = nil
      else
        if backend.down_since
          unless backend.core_application.suspended_mode
            REDIS.multi do
              REDIS.srem("#{prefix}|backends.up",         id.to_s)
              REDIS.sadd("#{prefix}|backends.still_down", id.to_s)
            end
          end
        else
          REDIS.multi do
            REDIS.srem("#{prefix}|backends.up",         id.to_s)
            REDIS.sadd("#{prefix}|backends.down",       id.to_s)
          end
        end

        backend.down_since  ||= Time.now
        backend.error_message = status[:error]
      end

      backend.save
    end

    Http::Router.send_to_redis
    Http::Passer.send_to_redis
    Http::Backend.send_to_redis

    render :json => { :status => 'OK' }

    # deliver email
    begin
      sending_email = !!REDIS.setnx("alice.http|sending_email", 'true')
      return unless sending_email

      last_email = Time.at(REDIS.get("alice.http|last_process_changes_email").to_i)
      return if last_email   > 5.minutes.ago

      changes = {
        routers: {
          up:         REDIS.smembers("#{prefix}|routers.up"),
          down:       REDIS.smembers("#{prefix}|routers.down"),
          still_down: REDIS.sdiff("#{prefix}|routers.still_down", "#{prefix}|routers.down")
        },
        passers: {
          up:         REDIS.smembers("#{prefix}|passers.up"),
          down:       REDIS.smembers("#{prefix}|passers.down"),
          still_down: REDIS.sdiff("#{prefix}|passers.still_down", "#{prefix}|passers.down")
        },
        backends: {
          up:         REDIS.smembers("#{prefix}|backends.up"),
          down:       REDIS.smembers("#{prefix}|backends.down"),
          still_down: REDIS.sdiff("#{prefix}|backends.still_down", "#{prefix}|backends.down")
        }
      }

      REDIS.del "#{prefix}|routers.up"
      REDIS.del "#{prefix}|routers.down"
      REDIS.del "#{prefix}|routers.still_down"
      REDIS.del "#{prefix}|passers.up"
      REDIS.del "#{prefix}|passers.down"
      REDIS.del "#{prefix}|passers.still_down"
      REDIS.del "#{prefix}|backends.up"
      REDIS.del "#{prefix}|backends.down"
      REDIS.del "#{prefix}|backends.still_down"

      more_than_twenty_minutes_ago = (last_email < 20.minutes.ago)
      changes.each do |key, groups|
        set = groups[:up]
        groups.delete :up if set.blank?

        set = groups[:down]
        groups.delete :down if set.blank?

        set = groups[:still_down]
        groups.delete :still_down if set.blank?

        changes.delete key if groups.empty?
        changes.delete key if !more_than_twenty_minutes_ago and groups.keys == [:still_down]
      end

      return if changes.empty?

      changes.each do |key, groups|
        groups.each do |g, ids|
          case key
          when :routers
            groups[g] = Http::Router.find(ids)
          when :passers
            groups[g] = Http::Passer.find(ids)
          when :backends
            groups[g] = Http::Backend.find(ids)
          end
        end
      end

      REDIS.set("alice.http|last_process_changes_email", Time.now.to_i)
      Http::ProcessStateMailer.changes(changes).deliver

    ensure
      REDIS.del('alice.http|sending_email') if sending_email
    end
  end

  def tasks
    machine = Core::Machine.where(host: params[:machine_host]).first

    unless machine
      render :json => { :status => 'FAIL' }, :status => 404
      return
    end

    response.etag = [machine.updated_at.to_i]
    if request.fresh?(response)
      head :not_modified
      return
    end

    applications = Core::Application.all
    releases     = Core::Release.where(id: applications.map(&:active_core_release_id)).all
    definitions  = Pluto::ProcessDefinition.where(owner_type: 'Core::Release', owner_id: releases.map(&:id)).all
    instances    = Pluto::ProcessInstance.where(core_machine_id: machine.id, pluto_process_definition_id: definitions.map(&:id)).all

    render :json => instances
  end

end

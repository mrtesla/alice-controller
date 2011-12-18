class PingController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout false

  def router
    machine = Core::Machine.where(host: params[:host]).first

    if machine
      router = machine.http_routers.where(port: params[:port].to_i)
      router = (router.first or router.create)
      router.last_seen_at = Time.now
      router.save
    end

    render text: 'OK'
  end

  def passer
    machine = Core::Machine.where(host: params[:host]).first

    if machine
      passer = machine.http_passers.where(port: params[:port].to_i)
      passer = (passer.first or passer.create)
      passer.last_seen_at = Time.now
      passer.save
    end

    render text: 'OK'
  end
end

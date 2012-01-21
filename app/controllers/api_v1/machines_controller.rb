class ApiV1::MachinesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout false

  def routers
    machine = Core::Machine.where(host: params[:machine]).first

    unless machine
      render :json => { :status => 'FAIL' }, :status => 404
      return
    end

    endpoints = {}
    endpoints['routers'] = machine.http_routers.where(down_since: nil).all.map do |router|
      host = router.core_machine.host
      host = '127.0.0.1' if host == 'localhost'
      { id: router.id, host: host, port: router.port }
    end

    render :json => endpoints
  end
end

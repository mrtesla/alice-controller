class ApiV1::ApplicationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout false

  def register_static_paths
    application = Core::Application.where(name: params[:application]).first

    unless application
      render :json => { :status => 'FAIL' }, :status => 404
      return
    end

    ActiveRecord::Base.transaction do
      application.http_path_rules.where(static: true).destroy_all

      params[:rules].each do |(path, actions)|
        application.http_path_rules.create(path: path, actions: actions, static: true)
      end
    end

    application.send_to_redis

    render :json => { :status => 'OK' }
  end

  def maintenance_mode_on
    application = Core::Application.where(name: params[:application]).first

    unless application
      render :json => { :status => 'FAIL' }, :status => 404
      return
    end

    application.maintenance_mode = true
    application.save

    render :json => { :status => 'OK' }
  end

  def maintenance_mode_off
    application = Core::Application.where(name: params[:application]).first

    unless application
      render :json => { :status => 'FAIL' }, :status => 404
      return
    end

    application.maintenance_mode = false
    application.save

    render :json => { :status => 'OK' }
  end

end

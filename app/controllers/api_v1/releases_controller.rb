class ApiV1::ReleasesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout false

  def create
    application = Core::Application.where(name: params[:application]).first
    release     = nil

    unless application
      render :json => { :status => 'FAIL' }, :status => 404
      return
    end

    ActiveRecord::Base.transaction do
      release = application.core_releases.create!
      release.core_machines = Core::Machine.where(:host => (params[:machines] || [])).all

      (params[:path_rules] || []).each do |(path, actions)|
        release.http_path_rules.create(path: path, actions: actions)
      end

      (params[:environment] || {}).each do |name, value|
        release.pluto_environment_variables.create(name: name, value: value)
      end

      (params[:processes] || {}).each do |name, command|
        release.pluto_process_definitions.create(name: name, command: command)
      end
    end

    application.send_to_redis

    # reload environment_variables
    release.pluto_environment_variables(true)

    env = application.resolved_pluto_environment_variables(release)
    release = {
      id:          release.id,
      number:      release.number,
      environment: env.inject({}) do |h, var|
        h[var.name] = var.value
        h
      end
    }
    render :json => { status: 'OK', release: release }
  end

  def destroy
    release     = Core::Release.find(params[:id])
    application = release.core_application

    release.destroy

    application.send_to_redis

    render :json => { status: 'OK' }
  end

  def activate
    release     = Core::Release.find(params[:id])
    application = release.core_application

    application.active_core_release = release
    application.save!

    render :json => { status: 'OK' }
  end
end

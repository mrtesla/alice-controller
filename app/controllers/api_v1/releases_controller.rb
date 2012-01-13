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

      params[:path_rules].each do |(path, actions)|
        release.http_path_rules.create(path: path, actions: actions)
      end
    end

    application.send_to_redis

    # should return environment for rake tasks
    render :json => { status: 'OK', release: { id: release.id, number: release.number } }
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

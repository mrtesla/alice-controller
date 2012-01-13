class ApiV1::ReleasesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout false

  def create
    application = Core::Application.where(name: params[:application]).first

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

    # should return environment for rake tasks
    render :json => { :status => 'OK' }
  end

  def destroy

  end

  def activate

  end
end

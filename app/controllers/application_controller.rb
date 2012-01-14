class ApplicationController < ActionController::Base
  protect_from_forgery

private

  def load_core_application
    @core_application = Core::Application.find(params[:application_id])
  end

end

class FrontendController < ActionController::Base
  protect_from_forgery with: :exception

  def ember
    render 'ember/index'
  end
end

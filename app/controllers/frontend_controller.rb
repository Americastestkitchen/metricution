class FrontendController < ActionController::Base
  protect_from_forgery with: :exception

  def client
    render 'client/index'
  end
end

# FrontendController
# Controller for serving the frontend application. No real logic
# should be performed in this controller.
#
class FrontendController < ActionController::Base
  protect_from_forgery with: :exception

  def client
    render 'client/index'
  end
end

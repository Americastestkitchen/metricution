class BackendController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def record_not_found(error)
    respond_to do |format|
      format.json do
        render json: { error: error.message }, status: :not_found
      end
      format.xml do
        render xml: { error: error.message }, status: :not_found
      end
    end
  end
end

# BackendController
# Base controller for the backend, serving JSON exclusively.
#
class BackendController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_json
  rescue_from ActionController::ParameterMissing, with: :parameter_missing_json

  protected

  def record_not_found_json(error)
    error_json(error, :not_found)
  end

  def parameter_missing_json(error)
    error_json(error, :unprocessable_entity)
  end

  def error_json(error, status)
    render json: { error: error.message }, status: status
  end
end

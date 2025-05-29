class ApplicationController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_record

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?

    if token
      decoded = JsonWebToken.decode(token)
      if decoded
        @current_user = User.find_by(id: decoded[:user_id])
        return render json: { errors: ['User not found'] }, status: :unauthorized unless @current_user
      else
        render json: { errors: ['Invalid token'] }, status: :unauthorized
      end
    else
      render json: { errors: ['Missing token'] }, status: :unauthorized
    end
  end

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def unprocessable_record(exception)
    render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end

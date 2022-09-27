module Api::V1::AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token, if: ->(c) { c.request.format == "application/json" }
    protect_from_forgery with: :exception, unless: -> { request.format.json? }
    before_action :authenticate_user
    before_action :authenticate_user!
  end

  private

  def authenticate_user
    if request.headers['Authorization'].present?
      authenticate_or_request_with_http_token do |token|
        begin
          jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
          @current_user_id = jwt_payload['id']
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          head :unauthorized
        end
      end
    end
  end

  def authenticate_user!(options = {})
    render json: {
      message: 'Please sign in to continue'
    }, status: :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end
end

module Api::V1::ResponseRenderer
  extend ActiveSupport::Concern

  def render_unprocessable_entity(message, data: {})
    render json: {
      messages: "Mobile is not verified",
      is_success: false,
      data: data
    }, status: :unprocessable_entity
  end
end

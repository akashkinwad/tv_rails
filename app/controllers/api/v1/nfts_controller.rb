module Api
  module V1
    class NftsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def sign_nft
        service = SignNft.new(params['nft'].to_json)
        response = service.generate_signature
        render json: response
      end

    end
  end
end

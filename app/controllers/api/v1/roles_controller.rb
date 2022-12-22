module Api
  module V1
    class RolesController < ApplicationController
      def index
        @roles = Role.all
      end
    end
  end
end

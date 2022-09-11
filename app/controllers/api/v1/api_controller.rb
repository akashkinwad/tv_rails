module Api::V1
  class ApiController < ApplicationController
    include AuthenticationConcern
  end
end

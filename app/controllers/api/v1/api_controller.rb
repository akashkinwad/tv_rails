module Api::V1
  class ApiController < ApplicationController
    include AuthenticationConcern
    include ApplicationHelper
  end
end

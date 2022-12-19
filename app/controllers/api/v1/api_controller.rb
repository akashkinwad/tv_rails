module Api::V1
  class ApiController < ApplicationController
    include AuthenticationConcern
    include UploadToS3
    include ApiHelper
  end
end

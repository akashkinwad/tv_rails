class HomeController < ApplicationController
  layout false

  def index
  end

  def show
    render template: "home/#{params[:page]}"
  end
end

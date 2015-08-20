class ErrorsController < ApplicationController
  def file_not_found
  	render status: :not_found
  end

  def unprocessable
  	render :status => 422
  end

  def internal_server_error
  	render :status => 500
  end
end

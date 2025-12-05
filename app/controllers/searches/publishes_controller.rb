class Searches::PublishesController < ApplicationController
  include SearchScoped

  def update
    @search.update!(status: params[:status])

    respond_to do |format|
      format.html { redirect_to @search }
      format.turbo_stream
    end
  end
end

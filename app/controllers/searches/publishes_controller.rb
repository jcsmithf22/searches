class Searches::PublishesController < ApplicationController
  include SearchScoped

  def update
    @search.update!(status: params[:status])
    redirect_to @search
  end
end

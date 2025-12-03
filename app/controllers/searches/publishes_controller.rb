class Searches::PublishesController < ApplicationController
  include SearchScoped

  def create
    @search.publish
    redirect_to searches_path
  end
end

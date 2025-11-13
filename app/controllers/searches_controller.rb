class SearchesController < ApplicationController
  allow_unauthenticated_access

  def index
    @searches = Search.all
  end

  def new
    @searches = Search.new
  end
end

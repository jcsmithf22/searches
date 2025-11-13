class SearchesController < ApplicationController
  allow_unauthenticated_access

  def index
    @searches = Search.all
  end
end

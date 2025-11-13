class SearchesController < ApplicationController
  allow_unauthenticated_access

  def index
    @searches = Search.all
  end

  def new
    @search = Search.new
  end

  def create
    puts params
  end
end

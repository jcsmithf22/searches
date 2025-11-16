class SearchesController < ApplicationController
  allow_unauthenticated_access only: %i[ new ]
  before_action :set_search, only: %i[ edit ]

  def index
    @search = Search.new
    @searches = Current.user.searches.order(created_at: :desc)
  end

  def new
    @search = Search.new
  end

  def search
    @search = Current.user.searches.new(search_params.compact_blank)
    if @search.valid?
      result = EbayService.search(@search)
      @total = result[:total]
      @results = result[:results]
    end
  end

  def create
    @search = Current.user.searches.new(search_params)
    if @search.save
      redirect_to searches_path, notice: "Search saved successfully!"
    else
      flash[:alert] = "Failed to save search"
      render :search, status: :unprocessable_entity
    end
  end

  def edit
  end

  private

  def set_search
    @search = Current.user.searches.find(params[:id])
  end

  def search_params
    params.expect(search: [ :name, :notes, :query, :category_ids, :buying_options, :conditions, :minimum, :maximum, :search_in_description, :search_or_save ])
  end
end

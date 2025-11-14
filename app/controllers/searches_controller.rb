class SearchesController < ApplicationController
  allow_unauthenticated_access only: %i[ new ]

  def index
    @searches = Search.all
  end

  def new
    @search = Search.new
  end

  def search
    @search = Current.user.searches.new(search_params.compact_blank)
    if @search.valid?
      test = EbayService.search(@search)
      puts test
      @results = execute_search(@search)
    end
  end

  def create
    @search = Current.user.searches.new(search_params)
    if @search.save
      redirect_to searches_path, notice: "Search saved successfully!"
    else
      flash[:alert] = "Failed to save search"
      render :execute, status: :unprocessable_entity
    end
  end

  private

  def search_params
    params.require(:search).permit(:query, :category_ids, :buying_options, :conditions, :minimum, :maximum, :search_in_description)
  end

  def execute_search(search)
    # TODO: Implement actual search logic
    # Return mock results for now
    [
      { title: "Result 1", price: "$10.00" },
      { title: "Result 2", price: "$15.00" }
    ]
  end
end

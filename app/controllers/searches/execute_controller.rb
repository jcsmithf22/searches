class Searches::ExecuteController < ApplicationController
  def new
    @search = Current.user.searches.new(search_params.compact_blank)

    if @search.valid?
      execute_search
    end
  end

  def existing
    @search = Current.user.searches.find(params[:id])
    execute_search
  end

  private

  def execute_search
    result = EbayService.search(@search)
    @total = result[:total]
    @results = result[:results]
  end

  def search_params
    params.expect(search: [ :name, :notes, :query, :category_ids, :buying_options, :conditions, :minimum, :maximum, :search_in_description, :search_or_save ])
  end
end

class SearchesController < ApplicationController
  # allow_unauthenticated_access only: %i[ new ]
  before_action :set_search, only: %i[ edit update ]

  def index
    @search = Search.new
    @searches = Current.user.searches.order(created_at: :desc)
  end

  def new
    # @search = Search.new
    @search = Current.user.searches.new(optional_search_params.compact_blank)
  end

  def create
    @search = Current.user.searches.new(search_params)
    respond_to do |format|
      if @search.save
        format.html { redirect_to @search, notice: "Search created successfully!" }
      else
        format.html { render "searches/execute/show", status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to searches_path, notice: "Search updated successfully!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_search
    @search = Current.user.searches.find(params[:id])
  end

  def search_params
    params.expect(search: [ :name, :notes, :query, :category_ids, :buying_options, :conditions, :minimum, :maximum, :search_in_description, :search_or_save ])
  end

  def optional_search_params
    params.fetch(:search, {}).permit(:name, :notes, :query, :category_ids, :buying_options, :conditions, :minimum, :maximum, :search_in_description, :search_or_save)
  end
end

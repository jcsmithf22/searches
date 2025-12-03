class SearchesController < ApplicationController
  # allow_unauthenticated_access only: %i[ new ]
  before_action :set_search, only: %i[ show edit update ]

  def index
    @searches = Current.user.searches.published.order(created_at: :desc)
  end

  def new
    # @search = Current.user.searches.new(optional_search_params.compact_blank)
    @search = Current.user.searches.new
  end

  def show
  end

  def create
    @search = Current.user.searches.find_or_create_by!(user: Current.user, status: "drafted")
    redirect_to edit_search_path(@search)
  end

  def edit
  end

  def update
    if @search.update(search_params)
      redirect_to searches_path, notice: "Search updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_search
    @search = Current.user.searches.find(params[:id])
  end

  def search_params
    params.expect(search: [ :name, :notes, :query, :category_ids, :buying_options, :conditions, :minimum, :maximum, :search_in_description ])
  end

  def optional_search_params
    params.fetch(:search, {}).permit(:name, :notes, :query, :category_ids, :buying_options, :conditions, :minimum, :maximum, :search_in_description, :search_or_save)
  end
end

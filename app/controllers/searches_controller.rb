class SearchesController < ApplicationController
  # allow_unauthenticated_access only: %i[ new ]
  before_action :set_search, only: %i[ show edit update ]

  def index
    @searches = Current.user.searches.order(created_at: :desc)
  end

  def new
    @search = Current.user.searches.new
  end

  def show
  end

  def create
    @search = Current.user.searches.new(search_params)
    if @search.save
      redirect_to searches_path
    else
      render :new, status: :unprocessable_entity
    end
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
    params.expect(search: [ :name, :notes, :query, :category_ids, :buying_options, :conditions, :minimum, :maximum, :search_in_description, :status ])
  end

  def optional_search_params
    params.fetch(:search, {}).permit(:name, :notes, :query, :category_ids, :buying_options, :conditions, :minimum, :maximum, :search_in_description, :search_or_save)
  end
end

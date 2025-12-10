class SearchesController < ApplicationController
  before_action :set_search, only: %i[ show edit update destroy ]
  before_action :set_pins, only: %i[ index new show edit ]

  def index
    @searches = Current.user.searches.order(name: :asc).with_pinned(Current.user)
  end

  def new
    @search = Current.user.searches.new
  end

  def show
  end

  def create
    @search = Current.user.searches.new(search_params)
    if @search.save
      redirect_to @search
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @search.update(search_params)
      redirect_to @search
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @search.destroy!
    redirect_to searches_path
  end

  private

  def set_search
    @search = Current.user.searches.find(params[:id])
  end

  def set_pins
    @pins = Current.user.pinned_searches
  end

  def search_params
    params.expect(search: [ :name, :notes, :query, :category_ids, :buying_options, :conditions, :minimum, :maximum, :search_in_description ])
  end
end

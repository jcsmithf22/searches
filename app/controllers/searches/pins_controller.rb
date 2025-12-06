class Searches::PinsController < ApplicationController
  include SearchScoped

  def update
    if @search.pinned_by?(Current.user)
      @search.unpin_by(Current.user)
    else
      @search.pin_by(Current.user)
    end

    redirect_to searches_path

    # respond_to do |format|
    #   format.html { redirect_to @search }
    #   format.turbo_stream
    # end
  end
end

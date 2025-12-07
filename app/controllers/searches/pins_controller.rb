class Searches::PinsController < ApplicationController
  include SearchScoped

  def update
    if @search.pinned_by?(Current.user)
      @search.unpin_by(Current.user)
    else
      @search.pin_by(Current.user)
    end

    respond_to do |format|
      format.html { redirect_to @search }
      format.turbo_stream
    end
  end
end

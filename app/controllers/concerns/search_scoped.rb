module SearchScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_search
  end

  private
    def set_search
      @search = Current.user.searches.find(params[:search_id])
    end
end

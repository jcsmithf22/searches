module Search::Monetize
  extend ActiveSupport::Concern

  included do
    monetize :minimum_cents, allow_nil: true, numericality: {
      greater_than_or_equal_to: 0
    }
    monetize :maximum_cents, allow_nil: true, numericality: {
      greater_than_or_equal_to: 0
    }
  end

  def formatted_price_range
    if minimum && maximum
      "#{minimum.format} to #{maximum.format}"
    elsif maximum.present?
      "up to #{maximum.format}"
    elsif minimum.present?
      "#{minimum.format} and up"
    else
      "Any price"
    end
  end
end

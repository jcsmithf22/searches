module Search::Pinnable
  extend ActiveSupport::Concern

  included do
    has_many :pins, dependent: :destroy

    # scope :with_golden_first, -> { left_outer_joins(:goldness).prepend_order("card_goldnesses.id IS NULL").preload(:goldness) }
    # scope :with_pinned, -> { left_outer_joins(:pins).prepend_order("pins.id IS NOT NULL") }
  end

  class_methods do
    def with_pinned_first
      existing_orders = all.order_values
      left_outer_joins(:pins)
        .reorder(Arel.sql("pins.id IS NULL"))
        .order(existing_orders)
        # .preload(:pins)
    end
  end

  def pinned_by?(user)
    pins.exists?(user: user)
  end

  def pin_for(user)
    pins.find_by(user: user)
  end

  def pin_by(user)
    pins.find_or_create_by!(user: user)
  end

  def unpin_by(user)
    pins.find_by(user: user).tap { it.destroy }
  end
end

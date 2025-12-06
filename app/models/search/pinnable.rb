module Search::Pinnable
  extend ActiveSupport::Concern

  included do
    has_many :pins, dependent: :destroy
    scope :with_pinned_first, ->(user) {
      joins("LEFT OUTER JOIN pins ON pins.search_id = searches.id AND pins.user_id = #{user.id}")
        .select("searches.*, pins.id AS pin_id")
        .reorder(Arel.sql("pins.id IS NULL"))
        .order(all.order_values)
    }
  end

  def pinned?
    has_attribute?(:pin_id) && self[:pin_id].present?
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

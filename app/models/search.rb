class Search < ApplicationRecord
  include Ebay, Statuses

  belongs_to :user

  before_save :set_default_title, if: :published?

  monetize :minimum_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0
  }
  monetize :maximum_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0
  }

  # validates :query, presence: true, if: :published?
  # validates :name, presence: true, if: :published?

  private
    def set_default_title
      self.name = "Untitled" if name.blank?
    end
end

class Search < ApplicationRecord
  include Ebay

  belongs_to :user
  monetize :minimum_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0
  }
  monetize :maximum_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0
  }

  validates :query, presence: true
end

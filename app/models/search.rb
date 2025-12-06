class Search < ApplicationRecord
  include Ebay, Statuses, Monetize, Pinnable

  belongs_to :user

  validates :query, presence: true
  validates :name, presence: true
end

class Search < ApplicationRecord
  belongs_to :user
  monetize :minimum_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0
  }
  monetize :maximum_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0
  }


  validates :query, presence: true

  CATEGORY_OPTIONS = {
    "101" => "Books",
    "102" => "Movies",
    "103" => "Music",
    "104" => "Games",
    "105" => "Software",
    "106" => "Pictures",
    "107" => "Videos",
    "108" => "Applications",
    "109" => "Other"
  }

  BUYING_OPTIONS = {
    "FIXED_PRICE" => "Buy it now",
    "AUCTION" => "Auction",
    "BEST_OFFER" => "Best offer"
  }

  CONDITION_OPTIONS = {
    "UNSPECIFIED" => "Unspecified",
    "NEW" => "New",
    "USED" => "Used"
  }

  def self.category_options_for_select
    CATEGORY_OPTIONS.invert.to_a
  end

  def self.buying_options_for_select
    BUYING_OPTIONS.invert.to_a
  end

  def self.condition_options_for_select
    CONDITION_OPTIONS.invert.to_a
  end
end

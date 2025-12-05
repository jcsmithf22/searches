module Search::Ebay
  extend ActiveSupport::Concern

  CATEGORY_OPTIONS = {
    "20081" => "Antiques",
    "550" => "Art",
    "2984" => "Baby",
    "267" => "Books & Magazines",
    "12576" => "Business & Industrial",
    "625" => "Cameras & Photo",
    "15032" => "Cell Phones & Accessories",
    "11450" => "Clothing, Shoes & Accessories",
    "11116" => "Coins & Paper Money",
    "1" => "Collectibles",
    "58058" => "Computers, Tablets & Networking",
    "293" => "Consumer Electronics",
    "14339" => "Crafts",
    "237" => "Dolls & Bears",
    "11232" => "Movies & TV",
    "45100" => "Entertainment Memorabilia",
    "172008" => "Gift Cards & Coupons",
    "26395" => "Health & Beauty",
    "11700" => "Home & Garden",
    "281" => "Jewelry & Watches",
    "11233" => "Music",
    "619" => "Musical Instruments & Gear",
    "1281" => "Pet Supplies",
    "870" => "Pottery & Glass",
    "10542" => "Real Estate",
    "316" => "Specialty Services",
    "888" => "Sporting Goods",
    "64482" => "Sports Memorabilia, Cards & Fan Shop",
    "260" => "Stamps",
    "1305" => "Tickets & Experiences",
    "220" => "Toys & Hobbies",
    "3252" => "Travel",
    "1249" => "Video Games & Consoles",
    "99" => "Everything Else",
    "6000" => "eBay Motors"
  }.freeze

  BUYING_OPTIONS = {
    "FIXED_PRICE" => "Buy it now",
    "AUCTION" => "Auction",
    "BEST_OFFER" => "Best offer"
  }.freeze

  CONDITION_OPTIONS = {
    # "UNSPECIFIED" => "Unspecified", # This literally looks for listings without a condition specified
    "NEW" => "New",
    "USED" => "Used"
  }.freeze

  def readable_buying_option
    BUYING_OPTIONS[buying_options] || "Any"
  end

  def readable_condition_option
    CONDITION_OPTIONS[conditions] || "Unspecified"
  end

  def readable_category_option
    CATEGORY_OPTIONS[category_ids] || "All categories"
  end

  class_methods do
    def category_options_for_select
      CATEGORY_OPTIONS.invert.to_a
    end
    def buying_options_for_select
      BUYING_OPTIONS.invert.to_a
    end
    def condition_options_for_select
      CONDITION_OPTIONS.invert.to_a
    end
  end
end

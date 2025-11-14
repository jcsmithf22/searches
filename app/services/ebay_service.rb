# frozen_string_literal: true

class EbayService
  # CATEGORIES is a frozen hash, meaning it cannot be modified after definition
  # This prevents accidental modifications and improves thread safety
  # Example usage:
  #   EbayService::CATEGORIES[:books_and_magazines]  # Returns 267
  #   EbayService::CATEGORIES.fetch(:art)           # Returns 550, raises KeyError if not found
  CATEGORIES = {
    antiques: "20081",
    art: "550",
    baby: "2984",
    books_and_magazines: "267",
    business_and_industrial: "12576",
    cameras_and_photo: "625",
    cell_phones_and_accessories: "15032",
    clothing_shoes_and_accessories: "11450",
    coins_and_paper_money: "11116",
    collectibles: "1",
    computers_tablets_and_networking: "58058",
    consumer_electronics: "293",
    crafts: "14339",
    dolls_and_bears: "237",
    movies_and_tv: "11232",
    entertainment_memorabilia: "45100",
    gift_cards_and_coupons: "172008",
    health_and_beauty: "26395",
    home_and_garden: "11700",
    jewelry_and_watches: "281",
    music: "11233",
    musical_instruments_and_gear: "619",
    pet_supplies: "1281",
    pottery_and_glass: "870",
    real_estate: "10542",
    specialty_services: "316",
    sporting_goods: "888",
    sports_memorabilia_cards_and_fan_shop: "64482",
    stamps: "260",
    tickets_and_experiences: "1305",
    toys_and_hobbies: "220",
    travel: "3252",
    video_games_and_consoles: "1249",
    everything_else: "99",
    ebay_motors: "6000"
  }.freeze

  BUYING_OPTIONS = {
    all_listings: "FIXED_PRICE|AUCTION|BEST_OFFER|CLASSIFIED_AD",
    auction: "AUCTION",
    buy_it_now: "FIXED_PRICE",
    best_offer: "BEST_OFFER",
    classified_ad: "CLASSIFIED_AD"
  }.freeze

  attr_reader :search, :campaign_id

  def initialize(search, campaign_id: "123")
    @search = search
    @campaign_id = campaign_id
  end

  def self.search(search, campaign_id: "123")
    new(search, campaign_id: campaign_id).perform_ebay_search
  end

  def perform_ebay_search
    access_token = fetch_access_token
    request = Ebay.browse(
      campaign_id: @campaign_id,
      zip: 53075,
      access_token: access_token,
      # Consider making this configurable
      market_id: "EBAY_US",
      category_ids: search.category_ids.presence
    )

    filter_string = build_filter_string
    response = request.search(q: search.keywords, filter: filter_string, category_ids: search.category.presence)
    results = JSON.parse(response.body)
    # Rails.logger.info("eBay API response: #{results.inspect}")

    if results["errors"]
      error = results["errors"].first
      raise "eBay API Error: #{error["message"]} (#{error["errorId"]}) - #{error["longMessage"]}"
    end

    total_results = results["total"] || 0
    item_summaries = results["itemSummaries"] || []

    # Filter results by title if title_only is true
    # { results: search.title_only ? filter_results_by_title(item_summaries) : item_summaries, total: total_results }
    puts item_summaries
    { results: item_summaries, total: total_results }
  end

  private

  def fetch_access_token
    # Cache the token for 1 hour 55 minutes (eBay tokens typically last 2 hours)
    Rails.cache.fetch("ebay_access_token", expires_in: 6900.seconds) do
      Ebay.mint_access_token
    end
  end

  def build_filter_string
    filters = []
    range_str = price_range_string
    filters << "price:[#{range_str}]" if range_str
    filters << "priceCurrency:USD"
    # filters << "buyingOptions:{#{search.listing_type}}"
    # filters << "excludeSellers:{#{search.excluded_sellers_array.join("|")}"
    filters.join(",")
  end

  def price_range_string
    min = to_dollars(search.minimum_cents)
    max = to_dollars(search.maximum_cents)

    if min && max
      "#{min}..#{max}"
    elsif min
      "#{min}"
    elsif max
      "..#{max}"
    end
  end

  def to_dollars(cents)
    cents&.fdiv(100)
  end

  def filter_results_by_title(results)
    keywords_regex = Regexp.new(search.query.split.map { |word| Regexp.escape(word) }.join(".*"), "i")
    results.select { |item| item["title"] =~ keywords_regex }
  end
end

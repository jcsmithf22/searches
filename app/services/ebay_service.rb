# frozen_string_literal: true

class EbayService
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
    response = request.search(q: search.query, filter: filter_string, category_ids: search.category_ids.presence, limit: 10)
    results = JSON.parse(response.body)

    if results["errors"]
      error = results["errors"].first
      raise "eBay API Error: #{error["message"]} (#{error["errorId"]}) - #{error["longMessage"]}"
    end

    total_results = results["total"] || 0
    item_summaries = results["itemSummaries"] || []

    { results: item_summaries, total: total_results, filters: filter_string }
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
    filters << "price:[#{build_price_string}]"
    filters << "priceCurrency:USD"
    filters << "searchInDescription:#{search.search_in_description}"
    filters << "buyingOptions:{#{search.buying_options || "FIXED_PRICE|AUCTION|BEST_OFFER"}}"
    filters << "filter=conditionIds:{#{search.condition_ids}"
    filters << "conditions:{#{search.conditions}}"
    filters << "excludeSellers:{#{search.excluded_sellers}}"
    filters << "excludeCategoryIds:{#{search.excluded_category_ids}}"
    filters.join(",")
  end

  def build_price_string
    min = search.minimum
    max = search.maximum

    return "#{min}..#{max}" if min && max
    return "#{min}" if min
    return "..#{max}" if max
    nil
  end

  # Rails.logger.info("eBay API response: #{results.inspect}")
  # Deprecated
  # Filter results by title if title_only is true
  # { results: search.title_only ? filter_results_by_title(item_summaries) : item_summaries, total: total_results }
  def filter_results_by_title(results)
    keywords_regex = Regexp.new(search.query.split.map { |word| Regexp.escape(word) }.join(".*"), "i")
    results.select { |item| item["title"] =~ keywords_regex }
  end
end

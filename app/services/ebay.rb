# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "cgi"

# Simplified drop-in replacement for the Ebay module and its submodules.
# Usage:
#   EbaySimple.browse(access_token: token, campaign_id: "123", zip: "12345")
#   EbaySimple.mint_access_token
module Ebay
  # Returns a Browse instance for making search requests
  def self.browse(**params)
    Browse.new(**params)
  end

  # Mints an OAuth access token for API requests
  def self.mint_access_token
    uri = URI("https://api.ebay.com/identity/v1/oauth2/token")

    request = Net::HTTP::Post.new(uri)
    request.basic_auth(app_id, cert_id)
    request.set_form_data(
      "grant_type" => "client_credentials",
      "scope" => "https://api.ebay.com/oauth/api_scope"
    )

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise "eBay OAuth Error: #{response.code} #{response.message}"
    end

    JSON.parse(response.body).fetch("access_token")
  end

  def self.app_id
    Rails.application.credentials.ebay_app_id
  end

  def self.cert_id
    Rails.application.credentials.ebay_cert_id
  end

  # Browse API client for searching eBay listings
  class Browse
    attr_reader :access_token, :campaign_id, :zip, :market_id

    def initialize(access_token:, campaign_id:, reference_id: nil, country: nil, zip: nil, market_id: "EBAY_US", category_ids: nil)
      @access_token = access_token
      @campaign_id = campaign_id
      @reference_id = reference_id
      @country = country
      @zip = zip
      @market_id = market_id
      @category_ids = category_ids
    end

    # Performs a search on eBay's Browse API
    # Returns a Net::HTTPResponse object with .body containing JSON
    def search(params = {})
      query_string = URI.encode_www_form(params.compact)
      uri = URI("https://api.ebay.com/buy/browse/v1/item_summary/search?#{query_string}")

      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{access_token}"
      request["X-EBAY-C-MARKETPLACE-ID"] = market_id
      request["X-EBAY-C-ENDUSERCTX"] = build_enduser_context

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
    end

    private

    def build_enduser_context
      context = {
        "affiliateCampaignId" => @campaign_id,
        "affiliateReferenceId" => @reference_id,
        "contextualLocation" => build_contextual_location
      }.compact

      context.map { |k, v| "#{k}=#{v}" }.join(",")
    end

    def build_contextual_location
      location = { "country" => @country, "zip" => @zip }.compact
      return nil if location.empty?

      string = location.map { |k, v| "#{k}=#{v}" }.join(",")
      CGI.escape(string)
    end
  end
end

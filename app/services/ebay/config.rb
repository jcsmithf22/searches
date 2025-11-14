# frozen_string_literal: true

module Ebay
  module Config
    class << self
      def app_id
        Rails.application.credentials.ebay_app_id
      end

      def dev_id
        Rails.application.credentials.ebay_dev_id
      end

      def cert_id
        Rails.application.credentials.ebay_cert_id
      end
    end
  end
end

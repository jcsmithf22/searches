# frozen_string_literal: true

module Ebay
  module Requestable
    class << self
      private

      def included(base)
        class << base
          attr_accessor :endpoint
        end
      end
    end

    attr_writer :http

    attr_accessor :headers

    def market_id=(market_id)
      @headers ||= {}
      @headers["X-EBAY-SOA-GLOBAL-ID"] = market_id
    end

    def http
      @http ||= HTTP::Client.new
    end

    def endpoint
      @endpoint ||= self.class.endpoint
    end

    def sandbox
      @endpoint = endpoint.sub("ebay", "sandbox.ebay")
      self
    end

    def persistent(timeout: 5)
      self.http = http.persistent(endpoint, timeout: timeout)
      self
    end

    [ :timeout, :via, :through, :use ].each do |method_name|
      define_method(method_name) do |*args, &block|
        self.http = http.send(method_name, *args, &block)
        self
      end
    end
  end
end

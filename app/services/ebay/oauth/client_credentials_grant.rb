# frozen_string_literal: true

module Ebay
  module Oauth
    class Error < StandardError; end

    class ClientCredentialsGrant
      include Requestable

      VIEW_PUBLIC_DATA_SCOPE = "https://api.ebay.com/oauth/api_scope"

      self.endpoint = "https://api.ebay.com/identity/v1/oauth2/token"

      attr_reader :app_id

      attr_reader :cert_id

      attr_reader :scopes

      def initialize(app_id: Config.app_id, cert_id: Config.cert_id, scopes: [ VIEW_PUBLIC_DATA_SCOPE ])
        @app_id = app_id
        @cert_id = cert_id
        @scopes = scopes
      end

      def mint_access_token
        response = request
        raise Error, response.status.reason unless response.status.ok?

        JSON.parse(response).fetch("access_token")
      end

      def request
        http.basic_auth(user: app_id, pass: cert_id)
          .post(endpoint, form: payload)
      end

      private

        def payload
          {
            grant_type: "client_credentials",
            scope: scopes.join(" ")
          }
        end
    end
  end
end

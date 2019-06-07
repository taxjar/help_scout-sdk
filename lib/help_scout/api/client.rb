# frozen_string_literal: true

module HelpScout
  class API
    class Client
      attr_reader :authorize

      def initialize(authorize: true)
        @authorize = authorize
      end

      def connection
        @_connection ||= begin
          HelpScout::API::AccessToken.refresh! if authorize? && token_needs_refresh?
          build_connection
        end
      end

      private

      def authorize?
        authorize
      end

      def build_connection
        Faraday.new(url: BASE_URL) do |conn|
          conn.request :json
          conn.authorization(:Bearer, HelpScout.access_token.value) if authorize? && HelpScout.access_token&.value
          conn.response(:json, content_type: /\bjson$/)
          conn.adapter(Faraday.default_adapter)
        end
      end

      def token_needs_refresh?
        HelpScout.access_token.nil? || HelpScout.access_token.stale?
      end
    end
  end
end

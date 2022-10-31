# frozen_string_literal: true

module HelpScout
  class API
    class Client
      attr_reader :authorize

      def initialize(authorize: true)
        @authorize = authorize
      end

      def connection
        @_connection ||= build_connection.tap do |conn|
          if authorize?
            HelpScout::API::AccessToken.refresh!
            conn.request(:authorization, :Bearer, access_token) if access_token
          end
        end
      end

      private

      def access_token
        HelpScout.access_token&.value
      end

      def authorize?
        authorize
      end

      def build_connection
        Faraday.new(url: BASE_URL) do |conn|
          conn.request :json
          conn.response(:json, content_type: /\bjson$/)
          conn.adapter(Faraday.default_adapter)
        end
      end
    end
  end
end

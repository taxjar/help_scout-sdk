# frozen_string_literal: true

module HelpScout
  class API
    class Client
      attr_reader :authorize

      def initialize(authorize: true)
        @authorize = authorize
      end

      def connection
        @connection ||= begin
          HelpScout::API::AccessToken.refresh! if authorize? && HelpScout.access_token.nil?
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
    end
  end
end

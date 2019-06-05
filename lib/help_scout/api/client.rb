# frozen_string_literal: true

module HelpScout
  class API
    class Client
      def authorized_connection
        @authorized_connection ||= begin
          HelpScout::API::AccessToken.refresh! if HelpScout.access_token.nil?
          build_connection
        end
      end

      def unauthorized_connection
        @unauthorized_connection ||= begin
          build_connection(authorize: false)
        end
      end

      private

      def build_connection(authorize: true)
        Faraday.new(url: BASE_URL) do |conn|
          conn.request :json
          conn.authorization(:Bearer, HelpScout.access_token.value) if authorize && HelpScout.access_token&.value
          conn.response(:json, content_type: /\bjson$/)
          conn.adapter(Faraday.default_adapter)
        end
      end
    end
  end
end

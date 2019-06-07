# frozen_string_literal: true

module HelpScout
  class API
    class AccessToken
      class << self
        def create
          connection = HelpScout::API::Client.new(authorize: false).connection
          response = connection.post('oauth2/token', token_request_params)

          case response.status
          when 200 then new HelpScout::Response.new(response).body
          when 429 then raise HelpScout::API::ThrottleLimitReached, response.body&.dig('error')
          else raise HelpScout::API::InternalError, "unexpected response (status #{response.status})"
          end
        end

        def refresh!
          HelpScout.api.access_token = create
        end

        private

        def token_request_params
          @_token_request_params ||= {
            grant_type: 'client_credentials',
            client_id: HelpScout.app_id,
            client_secret: HelpScout.app_secret
          }
        end
      end

      attr_accessor :invalid
      attr_reader :expires_at, :expires_in, :value

      def initialize(params)
        @value = params[:access_token]
        @expires_in = params[:expires_in]
        return unless @expires_in
        @expires_at = Time.now.utc + expires_in
      end

      def expired?
        return false unless expires_at
        Time.now.utc > expires_at
      end

      def invalid?
        invalid
      end

      def invalidate!
        self.invalid = true
      end

      def stale?
        invalid? || expired?
      end
    end
  end
end

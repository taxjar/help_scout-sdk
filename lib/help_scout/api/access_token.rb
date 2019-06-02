# frozen_string_literal: true

module HelpScout
  class API
    class AccessToken
      class << self
        def create
          connection = HelpScout::API::Client.new.unauthorized_connection
          response = connection.post('oauth2/token', token_request_params)

          case response.status
          when 429 then raise ThrottleLimitReached, response.body&.dig('error')
          when 500, 501, 503 then raise InternalError, response.body&.dig('error')
          end

          new HelpScout::Response.new(response).body
        end

        def refresh!
          HelpScout.api.access_token = create
        end

        private

        def token_request_params
          @token_request_params ||= {
            grant_type: 'client_credentials',
            client_id: HelpScout.app_id,
            client_secret: HelpScout.app_secret
          }
        end
      end

      attr_reader :expires_at, :expires_in, :value

      def initialize(params)
        @value = params[:access_token]
        @expires_in = params[:expires_in]
        @expires_at = Time.now.utc + params[:expires_in]
      end

      def expired?
        Time.now.utc > expires_at
      end
    end
  end
end

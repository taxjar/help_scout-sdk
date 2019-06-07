# frozen_string_literal: true

require 'date'

module HelpScout
  class API
    class AccessToken
      class << self
        def create
          cache.present? ? fetch_token : request_token
        end

        def refresh!
          HelpScout.api.access_token = create
        end

        private

        def cache
          HelpScout.configuration.token_cache
        end

        def cache_key
          HelpScout.configuration.token_cache_key
        end

        def fetch_token
          if (cached_token_json = cache.read(cache_key))
            new(JSON.parse(cached_token_json, symbolize_names: true))
          else
            request_token.tap do |token|
              cache.write(cache_key, token.to_json, expires_in: token.expires_in)
            end
          end
        end

        def request_token
          connection = HelpScout::API::Client.new(authorize: false).connection
          response = connection.post('oauth2/token', token_request_params)

          case response.status
          when 200 then new HelpScout::Response.new(response).body
          when 429 then raise HelpScout::API::ThrottleLimitReached, response.body&.dig('error')
          else raise HelpScout::API::InternalError, "unexpected response (status #{response.status})"
          end
        end

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

        if params[:expires_at]
          @expires_at = DateTime.parse(params[:expires_at].to_s).to_time.utc
        elsif params[:expires_in]
          @expires_in = params[:expires_in].to_i
          @expires_at = (Time.now.utc + @expires_in)
        end
      end

      def as_json(*)
        {
          access_token: value,
          expires_in: expires_in,
          expires_at: expires_at
        }
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

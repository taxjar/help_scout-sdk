# frozen_string_literal: true

module HelpScout
  class API
    class AccessToken
      class Cache
        attr_reader :backend, :key

        def initialize(backend: nil, key: nil)
          @backend = backend || HelpScout.configuration.token_cache
          @key = key || HelpScout.configuration.token_cache_key
        end

        def configured?
          backend.present? && key.present?
        end

        def fetch_token(&token_request)
          raise ArgumentError, 'A request fallback block is required' unless block_given?

          if (cached_token_json = backend.read(key))
            AccessToken.new(JSON.parse(cached_token_json, symbolize_names: true))
          else
            token_request.call.tap { |token| write(token) }
          end
        end

        private

        def write(token)
          backend.write(key, token.to_json, expires_in: token.expires_in)
        end
      end
    end
  end
end

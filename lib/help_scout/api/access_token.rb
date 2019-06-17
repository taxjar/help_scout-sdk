# frozen_string_literal: true

require 'date'
require 'help_scout/api/access_token/cache'
require 'help_scout/api/access_token/request'

module HelpScout
  class API
    class AccessToken
      class << self
        def create
          cache = HelpScout::API::AccessToken::Cache.new
          request = HelpScout::API::AccessToken::Request.new

          cache.configured? ? cache.fetch_token { request.execute } : request.execute
        end

        def refresh!
          return HelpScout.api.access_token unless HelpScout.access_token.nil? || HelpScout.access_token.stale?

          HelpScout.api.access_token = create
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
          expires_at: expires_at
        }
      end

      def expired?
        return false unless expires_at

        Time.now.utc > expires_at
      end

      def invalid?
        !!invalid # rubocop:disable Style/DoubleNegation
      end

      def invalidate!
        cache = HelpScout::API::AccessToken::Cache.new

        cache.delete if cache.configured?

        self.invalid = true
      end

      def stale?
        invalid? || expired?
      end
    end
  end
end

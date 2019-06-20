# frozen_string_literal: true

module HelpScout
  class Configuration
    attr_accessor :app_id, :app_secret, :default_mailbox, :token_cache
    attr_reader :access_token
    attr_writer :token_cache_key

    DEFAULT_CACHE_KEY = 'help_scout_token_cache'

    def access_token=(token_value)
      return unless token_value

      @access_token = HelpScout::API::AccessToken.new(access_token: token_value)
    end

    def token_cache_key
      return @token_cache_key if defined?(@token_cache_key)

      @token_cache_key = DEFAULT_CACHE_KEY
    end
  end
end

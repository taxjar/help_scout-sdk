# frozen_string_literal: true

module HelpScout
  class Configuration
    attr_accessor :app_id, :app_secret, :default_mailbox, :token_cache
    attr_writer :token_cache_key

    DEFAULT_CACHE_KEY = 'help_scout_token_cache'

    def token_cache_key
      return @token_cache_key if defined?(@token_cache_key)

      @token_cache_key = DEFAULT_CACHE_KEY
    end
  end
end

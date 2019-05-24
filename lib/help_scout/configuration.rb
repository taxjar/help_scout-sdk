# frozen_string_literal: true

module HelpScout
  class Configuration
    attr_accessor(:access_token, :app_id, :app_secret, :api_key, :automatically_generate_tokens, :default_mailbox)

    def initialize
      @automatically_generate_tokens = true
    end
  end
end

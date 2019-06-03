# frozen_string_literal: true

module HelpScout
  class Configuration
    attr_accessor :app_id, :app_secret, :default_mailbox
    attr_reader :access_token

    def access_token=(token_value)
      HelpScout::API::AccessToken.new(access_token: token_value)
    end
  end
end

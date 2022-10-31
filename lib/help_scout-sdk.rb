# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'faraday'

require 'help_scout/version'

require 'help_scout/base'
require 'help_scout/modules/getable'
require 'help_scout/modules/listable'

require 'help_scout/api'
require 'help_scout/api/access_token'
require 'help_scout/api/client'
require 'help_scout/attachment'
require 'help_scout/configuration'
require 'help_scout/conversation'
require 'help_scout/customer'
require 'help_scout/folder'
require 'help_scout/mailbox'
require 'help_scout/response'
require 'help_scout/thread'
require 'help_scout/user'
require 'help_scout/util'

module HelpScout
  class << self
    attr_writer :configuration

    def access_token
      api.access_token
    end

    def api
      @_api ||= HelpScout::API.new
    end

    def app_id
      configuration.app_id
    end

    def app_secret
      configuration.app_secret
    end

    def configuration
      @_configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def default_mailbox
      configuration.default_mailbox
    end

    def reset!
      @_api = HelpScout::API.new
    end
  end
end

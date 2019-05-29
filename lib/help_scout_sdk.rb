# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'faraday'
require 'faraday_middleware'

require 'help_scout_sdk/version'
require 'help_scout_sdk/configuration'

require 'help_scout_sdk/modules/getable'

require 'help_scout_sdk/api'
require 'help_scout_sdk/base'
require 'help_scout_sdk/conversation'
require 'help_scout_sdk/folder'
require 'help_scout_sdk/mailbox'
require 'help_scout_sdk/mailbox_ref'
require 'help_scout_sdk/person'
require 'help_scout_sdk/response'
require 'help_scout_sdk/source'
require 'help_scout_sdk/thread'

module HelpScout
  class << self
    attr_accessor :configuration
  end

  def self.api
    HelpScout::API.new
  end

  def self.api_key
    configuration.api_key
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.default_mailbox
    configuration.default_mailbox
  end
end

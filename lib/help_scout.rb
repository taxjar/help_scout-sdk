# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'faraday'
require 'faraday_middleware'

require 'help_scout/version'
require 'help_scout/configuration'

require 'help_scout/modules/getable'

require 'help_scout/api'
require 'help_scout/base'
require 'help_scout/conversation'
require 'help_scout/folder'
require 'help_scout/mailbox'
require 'help_scout/mailbox_ref'
require 'help_scout/person'
require 'help_scout/response'
require 'help_scout/source'
require 'help_scout/thread'

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

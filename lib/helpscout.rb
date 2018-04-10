# frozen_string_literal: true

require 'json'
require 'faraday'
require 'faraday_middleware'

require 'helpscout/version'
require 'helpscout/configuration'

require 'helpscout/modules/getable'

require 'helpscout/api'
require 'helpscout/base'
require 'helpscout/conversation'
require 'helpscout/folder'
require 'helpscout/mailbox'
require 'helpscout/mailbox_ref'
require 'helpscout/person'
require 'helpscout/source'
require 'helpscout/thread'

module Helpscout
  class << self
    attr_accessor :configuration
  end

  def self.api
    Helpscout::API.new
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

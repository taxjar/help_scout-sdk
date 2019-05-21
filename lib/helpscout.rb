# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'faraday'
require 'faraday_middleware'

require 'helpscout/version'
require 'helpscout/configuration'

require 'helpscout/modules/getable'

require 'helpscout/access_token'
require 'helpscout/api'
require 'helpscout/base'
require 'helpscout/conversation'
require 'helpscout/customer'
require 'helpscout/folder'
require 'helpscout/mailbox'
require 'helpscout/mailbox_ref'
require 'helpscout/person'
require 'helpscout/response'
require 'helpscout/source'
require 'helpscout/thread'
require 'helpscout/user'
require 'helpscout/util'

module Helpscout
  class << self
    attr_accessor :configuration
  end

  def self.access_token
    configuration.access_token
  end

  def self.api
    Helpscout::API.new
  end

  def self.api_key
    configuration.api_key
  end

  def self.app_id
    configuration.app_id
  end

  def self.app_secret
    configuration.app_secret
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.default_mailbox
    configuration.default_mailbox
  end
end

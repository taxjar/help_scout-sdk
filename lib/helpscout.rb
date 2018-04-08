require 'faraday'
require 'faraday_middleware'

require 'helpscout/version'
require 'helpscout/configuration'

require 'helpscout/api'
require 'helpscout/conversation'
require 'helpscout/folder'
require 'helpscout/mailbox'

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

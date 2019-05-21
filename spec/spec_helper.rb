# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'

require 'awesome_print'
require 'vcr'
require 'webmock/rspec'

require 'help_scout-sdk'

Dotenv.load('.env', '.env.test')

def file_fixture(path)
  File.read("spec/fixtures/#{path}")
end

def model_name
  described_class.to_s.split('::').last.downcase
end

HelpScout.configure do |config|
  config.app_id = ENV.fetch('HELP_SCOUT_APP_ID')
  config.app_secret = ENV.fetch('HELP_SCOUT_APP_SECRET')
  config.access_token = ENV.fetch('HELP_SCOUT_ACCESS_TOKEN') { HelpScout::AccessToken.create }
  config.default_mailbox = ENV.fetch('TEST_MAILBOX_ID')
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock

  config.filter_sensitive_data("<HELP_SCOUT_ACCESS_TOKEN>") { HelpScout.access_token.token }
  config.filter_sensitive_data("<HELP_SCOUT_APP_ID>") { HelpScout.app_id }
  config.filter_sensitive_data("<HELP_SCOUT_APP_SECRET>") { HelpScout.app_secret }
  config.filter_sensitive_data("<TEST_MAILBOX_ID>") { HelpScout.default_mailbox }
  config.filter_sensitive_data("<TEST_CONVERSATION_ID>") {ENV["TEST_CONVERSATION_ID"] }
  config.filter_sensitive_data("<TEST_CUSTOMER_EMAIL>") {ENV["TEST_CUSTOMER_EMAIL"] }
  config.filter_sensitive_data("<TEST_CUSTOMER_ID>") {ENV["TEST_CUSTOMER_ID"] }
  config.filter_sensitive_data("<TEST_USER_EMAIL>") { ENV["TEST_USER_EMAIL"] }
  config.filter_sensitive_data("<TEST_USER_ID>") { ENV["TEST_USER_ID"] }
end

RSpec.configure do |config|
  config.order = :random

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.define_derived_metadata(file_path: %r{spec/unit}) do |metadata|
    metadata[:unit] = true
  end

  # Turn VCR off for unit specs
  config.around(:all, :unit) do |example|
    VCR.turn_off!
    example.run
    VCR.turn_on!
  end
end

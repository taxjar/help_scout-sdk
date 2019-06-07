# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'

require 'awesome_print'
require 'byebug'
require 'logger'
require 'pry'
require 'vcr'
require 'webmock/rspec'

require 'help_scout-sdk'

Dotenv.load('.env', '.env.test')

def access_token_json
  file_fixture('access_token.json')
end

def api_path(path_part)
  'https://api.helpscout.net/v2/' + path_part
end

def file_fixture(path)
  File.read("spec/fixtures/#{path}")
end

def model_name
  described_class.to_s.split('::').last.downcase
end

def logger
  @_logger ||= Logger.new($stdout, level: ENV.fetch('LOG_LEVEL', 'INFO'))
end

def valid_access_token
  file_fixture('access_token.json')
end

HelpScout.configure do |config|
  config.app_id = ENV.fetch('HELP_SCOUT_APP_ID')
  config.app_secret = ENV.fetch('HELP_SCOUT_APP_SECRET')
  config.access_token = ENV.fetch('HELP_SCOUT_ACCESS_TOKEN', nil)
  config.default_mailbox = ENV.fetch('TEST_MAILBOX_ID')
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { record: :once }
  config.configure_rspec_metadata!

  config.filter_sensitive_data('<HELP_SCOUT_ACCESS_TOKEN>') { HelpScout.access_token&.value }
  config.filter_sensitive_data('<HELP_SCOUT_ACCESS_TOKEN>') do |interaction|
    begin
      JSON.parse(interaction.response.body)['access_token']
    rescue JSON::ParserError => e
      logger.debug e.message
    end
  end
  config.filter_sensitive_data('Bearer <HELP_SCOUT_ACCESS_TOKEN>') do |interaction|
    interaction.request.headers['Authorization']
  end

  config.filter_sensitive_data('<HELP_SCOUT_APP_ID>') { HelpScout.app_id }
  config.filter_sensitive_data('<HELP_SCOUT_APP_SECRET>') { HelpScout.app_secret }
  config.filter_sensitive_data('<TEST_MAILBOX_ID>') { HelpScout.default_mailbox }
  config.filter_sensitive_data('<TEST_CONVERSATION_ID>') { ENV['TEST_CONVERSATION_ID'] }
  config.filter_sensitive_data('<TEST_CUSTOMER_EMAIL>') { ENV['TEST_CUSTOMER_EMAIL'] }
  config.filter_sensitive_data('<TEST_CUSTOMER_ID>') { ENV['TEST_CUSTOMER_ID'] }
  config.filter_sensitive_data('<TEST_THREAD_ID>') { ENV['TEST_THREAD_ID'] }
  config.filter_sensitive_data('<TEST_USER_EMAIL>') { ENV['TEST_USER_EMAIL'] }
  config.filter_sensitive_data('<TEST_USER_ID>') { ENV['TEST_USER_ID'] }
end

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed

  # Default to "doc" formatting for single spec runs
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Profile the 3 slowest examples
  config.profile_examples = 3

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

  # Auto-tag integration specs to use VCR
  config.define_derived_metadata(file_path: %r{spec/integration}) do |metadata|
    metadata[:vcr] = true
  end

  config.before(:each) do
    HelpScout.reset!
  end

  config.before(:each, :unit) do
    stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
      .to_return(body: access_token_json, headers: { 'Content-Type' => 'application/json' })
  end
end

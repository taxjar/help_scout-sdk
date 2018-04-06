require 'bundler/setup'
require 'dotenv/load'
require 'helpscout'
require 'vcr'
require 'webmock/rspec'

Helpscout.configure do |config|
  config.api_key = ENV.fetch('HELPSCOUT_API_KEY')
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
end

RSpec.configure do |config|
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

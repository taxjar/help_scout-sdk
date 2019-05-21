# frozen_string_literal: true

require "shared_examples/integration/getable"
require "shared_examples/integration/listable"

RSpec.describe Helpscout::User do
  let(:id) { ENV.fetch("TEST_USER_ID") }

  include_examples "getable integration"
  include_examples "listable integration"
end

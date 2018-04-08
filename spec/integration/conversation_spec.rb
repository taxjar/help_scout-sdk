# frozen_string_literal: true

require 'shared_examples/integration/getable'
require 'shared_examples/integration/listable'

RSpec.describe Helpscout::Conversation do
  let(:id) { ENV['TEST_CONVERSATION_ID'] }

  include_examples 'getable integration'
  include_examples 'listable integration'
end

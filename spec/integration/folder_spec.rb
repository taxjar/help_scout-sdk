# frozen_string_literal: true

require 'shared_examples/integration/listable'

RSpec.describe HelpScout::Folder do
  let(:id) { ENV.fetch('TEST_MAILBOX_ID') }

  include_examples 'listable integration'
end

# frozen_string_literal: true

require 'shared_examples/unit/getable'
require 'shared_examples/unit/listable'

RSpec.describe Helpscout::Conversation do
  include_examples 'getable unit', 'https://api.helpscout.net/v1/conversations/1234.json'
  include_examples 'listable unit', 'https://api.helpscout.net/v1/mailboxes/127439/conversations.json'
end

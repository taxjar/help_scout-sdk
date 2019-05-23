# frozen_string_literal: true

require 'shared_examples/unit/listable'

RSpec.describe Helpscout::Folder do
  include_examples 'listable unit', "https://api.helpscout.net/v2/mailboxes/#{Helpscout.default_mailbox}/folders/"
end

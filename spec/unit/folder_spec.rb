# frozen_string_literal: true

require 'shared_examples/unit/listable'

RSpec.describe HelpScout::Folder do
  include_examples 'listable unit', "https://api.helpscout.net/v2/mailboxes/#{HelpScout.default_mailbox}/folders/"
end

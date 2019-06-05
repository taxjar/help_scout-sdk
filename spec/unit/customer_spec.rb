# frozen_string_literal: true

require 'shared_examples/unit/listable'
require 'shared_examples/unit/getable'

RSpec.describe HelpScout::Customer do
  include_examples 'getable unit', 'https://api.helpscout.net/v2/customers/1'
  include_examples 'listable unit', 'https://api.helpscout.net/v2/customers'
end

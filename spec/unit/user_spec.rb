# frozen_string_literal: true

require 'shared_examples/unit/getable'
require 'shared_examples/unit/listable'

RSpec.describe Helpscout::User do
  include_examples 'getable unit', 'https://api.helpscout.net/v2/users/1'
  include_examples 'listable unit', 'https://api.helpscout.net/v2/users'
end

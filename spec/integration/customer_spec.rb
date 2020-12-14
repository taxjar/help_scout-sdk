# frozen_string_literal: true

require 'shared_examples/integration/getable'
require 'shared_examples/integration/listable'

RSpec.describe HelpScout::Customer do
  let(:id) { ENV.fetch('TEST_CUSTOMER_ID') }

  include_examples 'getable integration'
  include_examples 'listable integration'

  describe 'list' do
    it "finds customers filtered with query" do
      result = described_class.list(query: '(email="some@email.com")')
      expect(result).to be_a Array
      expect(result).to all(be_a(described_class))
    end
  end
end

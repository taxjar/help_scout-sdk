# frozen_string_literal: true

require 'shared_examples/integration/getable'
require 'shared_examples/integration/listable'

RSpec.describe Helpscout::Mailbox do
  let(:id) { ENV.fetch('TEST_MAILBOX_ID') }

  include_examples 'getable integration'
  include_examples 'listable integration'

  describe '#folders' do
    subject { described_class.get(id).folders }

    it 'returns an Array of Folders' do
      VCR.use_cassette('mailbox/folders', record: :once) do
        expect(subject).to be_a Array
        expect(subject).to all(be_a(Helpscout::Folder))
      end
    end
  end
end

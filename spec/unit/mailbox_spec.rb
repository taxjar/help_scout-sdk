# frozen_string_literal: true

require 'shared_examples/unit/listable'
require 'shared_examples/unit/getable'

RSpec.describe HelpScout::Mailbox do
  include_examples 'getable unit', 'https://api.helpscout.net/v1/mailboxes/1234.json'
  include_examples 'listable unit', 'https://api.helpscout.net/v1/mailboxes.json'

  describe '#folders' do
    subject { described_class.new(mailbox).folders }
    let(:body) { file_fixture('mailbox/folders.json') }
    let(:mailbox) { HelpScout::API.from_json(file_fixture('mailbox/get.json'))[:item] }

    before do
      stub_request(:get, 'https://api.helpscout.net/v1/mailboxes/1234/folders.json').
        to_return(body: body, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns an Array of Folders' do
      expect(subject).to be_a Array
      expect(subject).to all(be_a(HelpScout::Folder))
    end
  end
end

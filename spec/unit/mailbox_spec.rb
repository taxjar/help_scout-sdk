# frozen_string_literal: true

require 'shared_examples/unit/listable'
require 'shared_examples/unit/getable'

RSpec.describe HelpScout::Mailbox do
  include_examples 'getable unit', 'https://api.helpscout.net/v2/mailboxes/1'
  include_examples 'listable unit', 'https://api.helpscout.net/v2/mailboxes'

  describe '#folders' do
    subject { described_class.new(mailbox).folders }
    let(:body) { file_fixture('mailbox/folders.json') }
    let(:mailbox) { JSON.parse(file_fixture('mailbox/get.json')).deep_transform_keys { |k| k.underscore.to_sym } }

    before do
      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token').
        to_return(body: valid_access_token, headers: { 'Content-Type' => 'application/json' })
      stub_request(:get, 'https://api.helpscout.net/v2/mailboxes/1/folders/').
        to_return(body: body, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns an Array of Folders' do
      expect(subject).to be_a Array
      expect(subject).to all(be_a(HelpScout::Folder))
    end
  end
end

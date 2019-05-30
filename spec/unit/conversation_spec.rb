# frozen_string_literal: true

require 'shared_examples/unit/getable'
require 'shared_examples/unit/listable'

RSpec.describe HelpScout::Conversation do
  include_examples 'getable unit', 'https://api.helpscout.net/v1/conversations/1234.json'
  include_examples 'listable unit', 'https://api.helpscout.net/v1/mailboxes/127439/conversations.json'

  describe '.create' do
    subject { described_class.create(params) }
    let(:params) { { subject: 'Hello World' } }
    let(:location) { 'abc123' }

    before do
      stub_request(:post, 'https://api.helpscout.net/v1/conversations.json').
        with(body: params.to_json).
        to_return(status: 200, headers: { 'Location' => location })
    end

    it 'returns the location of the conversation' do
      expect(subject).to eq location
    end
  end

  describe '#update' do
    subject { described_class.new(params).update(new_params) }
    let(:params) { { id: id } }
    let(:id) { '1234' }
    let(:new_params) { params.merge(tags: ['bar']) }

    before do
      stub_request(:put, "https://api.helpscout.net/v1/conversations/#{id}.json").
        with(body: new_params.to_json).
        to_return(status: 200)
    end

    it 'returns true' do
      expect(subject).to be true
    end
  end
end

# frozen_string_literal: true

require 'shared_examples/unit/listable'

RSpec.describe HelpScout::Thread do
  let(:conversation_id) { ENV.fetch('TEST_CONVERSATION_ID') }

  describe '.list' do
    let(:body) { file_fixture('thread/list.json') }
    let(:path) { "conversations/#{ENV.fetch('TEST_CONVERSATION_ID')}/threads" }

    subject { described_class.list(conversation_id) }

    before do
      stub_request(:get, api_path(path)).to_return(
        body: body,
        status: 200,
        headers: {
          'Content-Type' => 'application/json'
        }
      )
    end

    it "returns an Array of #{described_class} objects" do
      expect(subject).to be_a Array
      expect(subject).to all(be_a(described_class))
    end

    context 'when page set' do
      let(:page) { 2 }
      let(:path) { "conversations/#{ENV.fetch('TEST_CONVERSATION_ID')}/threads?page=#{page}" }

      subject { described_class.list(conversation_id, page: page) }

      it 'gets second page' do
        subject
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe HelpScout::Attachment do
  describe '.create' do
    let(:conversation_id) { ENV.fetch('TEST_CONVERSATION_ID') }
    let(:thread_id) { ENV.fetch('TEST_THREAD_ID') }
    let(:params) do
      {
        file_name: 'file.txt',
        mime_type: 'text/plain',
        data: 'ZmlsZQ=='
      }
    end

    subject { described_class.create(conversation_id, thread_id, params) }

    before do
      path = "https://api.helpscout.net/v2/conversations/#{conversation_id}/threads/#{thread_id}/attachments"

      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
        .to_return(body: valid_access_token, headers: { 'Content-Type' => 'application/json' })

      stub_request(:post, path).with(body: HelpScout::Util.camelize_keys(params)).to_return(
        body: '',
        headers: { 'Content-Type' => 'application/json' },
        status: 201
      )
    end

    it 'returns true' do
      expect(subject).to be true
    end
  end
end

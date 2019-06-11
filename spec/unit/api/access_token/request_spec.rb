# frozen_string_literal: true

RSpec.describe HelpScout::API::AccessToken::Request do
  let(:request) { described_class.new }

  describe '#execute' do
    subject { request.execute }

    before do
      WebMock.reset!
      stub_request(:post, api_path('oauth2/token'))
        .to_return(
          status: status,
          body: body,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    context 'when the request is successful' do
      let(:status) { 200 }
      let(:body) { access_token_json }

      it 'returns an AccessToken instance from the requested response' do
        expected_token = HelpScout::API::AccessToken.new(JSON.parse(body, symbolize_names: true))
        requested_token = subject

        expect(requested_token.value).to eq(expected_token.value)
      end
    end

    context 'when the request is rate limited' do
      let(:status) { 429 }
      let(:error) { { error: 'Request was throttled' } }
      let(:body) { error.to_json }

      it 'raises an API::ThrottleLimitReached error' do
        expect { subject }.to raise_error(HelpScout::API::ThrottleLimitReached, error[:error])
      end
    end

    context 'when the request is not successful' do
      let(:status) { 500 }
      let(:body) { '' }

      it 'raises an API::InternalError error' do
        expect { subject }.to raise_error(HelpScout::API::InternalError, "unexpected response (status #{status})")
      end
    end
  end
end

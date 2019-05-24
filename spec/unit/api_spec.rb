# frozen_string_literal: true

RSpec.describe HelpScout::API do
  let(:api) { described_class.new }
  let(:client) { api.send(:client) }

  describe '#access_token=' do
    subject { api.access_token = new_token }

    context 'when a value is provided' do
      let(:new_token) { 'some_token' }

      it 'sets the Authorization header with the token' do
        expect { subject }.to change { api.access_token }.to(new_token)
      end
    end

    context 'when no value is provided' do
      let(:new_token) { nil }

      it 'does not set the Authorization header' do
        expect { subject }.not_to change { api.access_token }
      end
    end
  end

  describe '#access_token' do
    subject { api.access_token }

    context 'when no Authorization header is set' do
      let(:token) { 'other_token' }

      before { client.headers['Authorization'] = "Bearer #{token}" }

      it 'returns the access token' do
        expect(subject).to eq(token)
      end
    end

    context 'when no Authorization header is set' do
      before { client.headers['Authorization'] = nil }

      it { is_expected.to be_nil }
    end
  end

  describe '#fetch_access_token' do
    subject { api.fetch_access_token }

    before do
      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token').
        to_return(response)
    end

    context 'when the request is successful' do
      let(:response) do
        {
          body: { access_token: 'foo', expires_in: 7200 }.to_json,
          headers: { 'Content-Type' => 'application/json' },
          status: 200
        }
      end

      it 'returns a HelpScout::Response with matching body' do
        result = subject

        expect(result).to be_a HelpScout::Response
        expect(result.body.to_json).to include(response[:body])
      end
    end

    context 'when the request is throttled' do
      let(:response) do
        {
          body: '{}',
          headers: { 'Content-Type' => 'application/json' },
          status: 429
        }
      end

      it 'raises a ThrottleLimitReached error' do
        expect { subject }.to raise_error(HelpScout::API::ThrottleLimitReached)
      end
    end

    context 'when the request encounters a system error' do
      let(:response) do
        {
          body: '{}',
          headers: { 'Content-Type' => 'application/json' },
          status: 500
        }
      end

      it 'raises an InternalError error' do
        expect { subject }.to raise_error(HelpScout::API::InternalError)
      end
    end
  end

  shared_examples 'http request behavior' do |request_method|
    describe "##{request_method}" do
      let(:path) { 'v2/resource' }
      let(:request_body) { request_method == :get ? {} : { name: 'Matz' } }

      subject { api.send(request_method, path, request_body) }

      before do
        stub = stub_request(request_method, "https://api.helpscout.net/v2/#{path}")
        stub.with(body: request_body) if request_body
        stub.to_return(
          { headers: { 'Content-Type' => 'application/json' } }.merge(response)
        )
      end

      context 'when the request is successful' do
        let(:response) { { status: 200 } }

        it 'returns a HelpScout::Response object' do
          expect(subject).to be_a HelpScout::Response
        end
      end

      shared_examples 'error handling' do |context, status:, error:|
        context "when the response is #{context}" do
          let(:response) { { status: status } }

          it "raises a #{error} error" do
            expect { subject }.to raise_error(error)
          end
        end
      end

      include_examples 'error handling', 'a bad request', status: 400, error: HelpScout::API::BadRequest
      include_examples 'error handling', 'not found', status: 404, error: HelpScout::API::NotFound
      include_examples 'error handling', 'rate limited', status: 429, error: HelpScout::API::ThrottleLimitReached
      include_examples 'error handling', 'an internal error', status: [500, 501, 503].sample, error: HelpScout::API::InternalError # rubocop:disable Metrics/LineLength

      context 'when the request is not authorized' do
        let(:response) { { status: 401 } }
        let(:access_token_stub) do
          stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token').
            to_return(
              body: file_fixture('access_token.json'),
              headers: { 'Content-Type' => 'application/json' },
              status: 200
            )
        end

        before { access_token_stub }

        it 'raises a NotAuthorized error' do
          expect { subject }.to raise_error(HelpScout::API::NotAuthorized)
        end

        context 'and automatically_generate_tokens is configured to true' do
          before { HelpScout.configuration.automatically_generate_tokens = true }

          it 'attempts to fetch a new access token' do
            expect { subject }.to raise_error(HelpScout::API::NotAuthorized)

            expect(access_token_stub).to have_been_requested
          end
        end

        context 'and automatically_generate_tokens is configured to false' do
          before { HelpScout.configuration.automatically_generate_tokens = false }

          it 'does not attempt to fetch a new access token' do
            expect { subject }.to raise_error(HelpScout::API::NotAuthorized)

            expect(access_token_stub).not_to have_been_requested
          end
        end
      end
    end
  end

  include_examples 'http request behavior', :get
  include_examples 'http request behavior', :patch
  include_examples 'http request behavior', :post
  include_examples 'http request behavior', :put
end

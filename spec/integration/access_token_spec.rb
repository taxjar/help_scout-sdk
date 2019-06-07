# frozen_string_literal: true

require 'active_support/cache/memory_store'

RSpec.describe HelpScout::API::AccessToken do
  describe '.create' do
    subject { described_class.create }

    it 'returns an AccessToken' do
      expect(subject).to be_a described_class
    end

    context 'when caching is enabled' do
      let(:cache) { HelpScout.configuration.token_cache }
      let(:key) { HelpScout.configuration.token_cache_key }
      let(:token) { described_class.new(access_token: token_value) }
      let(:token_value) { 'caching-tokens' }

      before { HelpScout.configuration.token_cache = ActiveSupport::Cache::MemoryStore.new }
      after { HelpScout.configuration.token_cache = nil }

      context 'and the access token is set in the cache' do
        before { cache.write(key, token.to_json) }

        it 'returns a new AccessToken instance from the cached data' do
          # Since VCR handles all HTTP interactions in the integration tests
          # automatically, and we want this test to fail if an HTTP request is
          # made, we eject the cassette and shutoff VCR. This will cause the
          # spec to raise a WebMock::NetConnectNotAllowedError if a request
          # is made.
          VCR.eject_cassette
          VCR.turned_off do
            restored_token = subject

            expect(restored_token).to be_a(described_class)
            expect(restored_token.value).to eq(token_value)
          end
        end
      end

      context 'and the access token is not set in the cache' do
        it 'requests and returns a new access token from the API' do
          requested_token = subject

          expect(requested_token).to be_a(described_class)
          expect(requested_token.value).not_to eq(token_value)
        end

        it 'writes the token to the cache' do
          expect(cache).to receive(:write).with(key, kind_of(String), kind_of(Hash)).and_call_original

          subject
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'active_support/cache/memory_store'

RSpec.describe HelpScout::API::AccessToken::Cache do
  describe '#configured?' do
    let(:cache) { described_class.new }

    subject { cache.configured? }

    context 'when no cache is configured' do
      around { |example| with_config(token_cache: nil) { example.run } }

      it { is_expected.to be false }
    end

    context 'when no cache key is configured' do
      around { |example| with_config(token_cache_key: nil) { example.run } }

      it { is_expected.to be false }
    end

    context 'when backend and key are provided' do
      let(:configured_cache) do
        described_class.new(
          backend: double('backend'),
          key: 'a-key'
        )
      end

      subject { configured_cache.configured? }

      around { |example| with_config(token_cache: nil, token_cache_key: nil) { example.run } }

      it { is_expected.to be true }
    end
  end

  describe '#delete' do
    let(:backend) { ActiveSupport::Cache::MemoryStore.new }
    let(:cache) { described_class.new(backend: backend) }

    subject { cache.delete }

    it 'calls delete on the backend with the configured key' do
      expect(backend).to receive(:delete).with(cache.key)

      subject
    end
  end

  describe '#fetch_token' do
    let(:access_token_klass) { HelpScout::API::AccessToken }
    let(:backend) { ActiveSupport::Cache::MemoryStore.new }
    let(:cache) { described_class.new(backend: backend, key: key) }
    let(:token) { access_token_klass.new(access_token: '12345', expires_in: 7200) }
    let(:key) { 'some-unique-key' }

    context 'when a token request block is provided' do
      let(:token_request) { -> { raise 'Token request block should not be called' } }

      subject { cache.fetch_token(&token_request) }

      context 'and the cache is a hit' do
        around do |example|
          backend.write(key, token.to_json)
          example.run
          backend.delete(key)
        end

        it 'does not call the token_request block' do
          expect(token_request).not_to receive(:call)

          subject
        end

        it 'returns an AccessToken instance from the cached data' do
          fetched_token = subject

          expect(fetched_token).to be_an(access_token_klass)
          expect(fetched_token.value).to eq(token.value)
        end
      end

      context 'and the cache is a miss' do
        let(:new_value) { 'newtoken' }
        let(:new_token) { access_token_klass.new(access_token: new_value, expires_in: 7200) }
        let(:token_request) { -> { new_token } }

        it 'calls the token_request block' do
          expect(token_request).to receive(:call).and_return(new_token)

          subject
        end

        it 'writes the new token to the cache backend' do
          expect(backend).to receive(:write).with(
            key,
            new_token.to_json,
            hash_including(:expires_in)
          )

          subject
        end

        it 'returns an AccessToken instance from the requested response' do
          requested_token = subject

          expect(requested_token).to be_an(access_token_klass)
          expect(requested_token.value).to eq(new_value)
        end
      end
    end

    context 'when no token request block is provided' do
      subject { cache.fetch_token }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'A request fallback block is required')
      end
    end
  end
end

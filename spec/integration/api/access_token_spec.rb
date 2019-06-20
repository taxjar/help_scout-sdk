# frozen_string_literal: true

require 'active_support/cache/memory_store'

RSpec.describe HelpScout::API::AccessToken do
  describe '.create' do
    subject { described_class.create }

    it 'returns an AccessToken' do
      expect(subject).to be_a described_class
    end

    context 'when caching is configured' do
      let(:cache) { double('token_cache') }

      around { |example| with_config(token_cache: cache) { example.run } }

      it 'attempts to fetch the token from the cache' do
        expect_any_instance_of(HelpScout::API::AccessToken::Cache).to receive(:fetch_token)

        subject
      end
    end

    context 'when caching is not configured' do
      around { |example| with_config(token_cache: nil) { example.run } }

      it 'attempts to request a token' do
        expect_any_instance_of(HelpScout::API::AccessToken::Request).to receive(:execute)

        subject
      end
    end
  end
end

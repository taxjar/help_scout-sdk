# frozen_string_literal: true

RSpec.describe HelpScout::API::AccessToken do
  let(:access_token_json) { file_fixture('access_token.json') }
  let(:access_token_params) { JSON.parse(access_token_json, symbolize_names: true) }
  let(:access_token) { described_class.new(access_token_params) }

  before do
    stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
      .to_return(body: access_token_json, headers: { 'Content-Type' => 'application/json' })
  end

  describe '.create' do
    subject { described_class.create }

    it { is_expected.to be_a described_class }
  end

  describe '#value' do
    subject { access_token.value }

    it { is_expected.to eq(access_token_params[:access_token]) }
  end

  describe '#expires_in' do
    subject { access_token.expires_in }

    it { is_expected.to eq(access_token_params[:expires_in]) }
  end

  describe '#expired?' do
    subject { access_token.expired? }

    context 'when the token is likely to be expired' do
      let(:access_token_params) { super().merge(expires_in: -100) }

      it { is_expected.to eq true }
    end

    context 'when the token is not likely to be expired' do
      it { is_expected.to eq false }
    end
  end
end

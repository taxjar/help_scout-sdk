# frozen_string_literal: true

RSpec.describe HelpScout::AccessToken do
  let(:access_token_json) { file_fixture('access_token.json') }
  let(:access_token_params) { JSON.parse(access_token_json, symbolize_names: true) }
  let(:access_token) { described_class.new(access_token_params) }

  before do
    stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token').
      to_return(body: access_token_json, headers: { 'Content-Type' => 'application/json' })
  end

  describe '.create' do
    subject { described_class.create }

    it { is_expected.to be_a HelpScout::AccessToken }
  end

  describe '.update' do
    let(:new_token_params) do
      {
        access_token: 'foo',
        expires_in: 7200
      }
    end

    subject { described_class.update(new_token_params) }

    it 'sets the access_token configuration value' do
      expect_any_instance_of(
        HelpScout::Configuration
      ).to receive(:access_token=)

      subject
    end

    it 'sets the access_token on the API client' do
      expect_any_instance_of(
        HelpScout::API
      ).to receive(:access_token=).with(new_token_params[:access_token])

      subject
    end
  end

  describe '#token' do
    subject { access_token.token }

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

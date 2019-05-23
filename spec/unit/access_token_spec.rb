# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HelpScout::AccessToken do
  let(:body) { file_fixture('access_token.json') }
  let(:access_token) { described_class.create }

  before do
    stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token.json').
      to_return(body: body, headers: { 'Content-Type' => 'application/json' })
  end

  describe '.create' do
    subject { described_class.create }

    it { is_expected.to be_a HelpScout::AccessToken }
  end

  describe '#token' do
    subject { access_token.token }

    it { is_expected.to eq(JSON.parse(body)['access_token']) }
  end

  describe '#expires_in' do
    subject { access_token.expires_in }

    it { is_expected.to eq(JSON.parse(body)['expires_in']) }
  end
end

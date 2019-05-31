# frozen_string_literal: true

RSpec.shared_examples 'getable unit' do |url|
  before do
    stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token').
      to_return(body: valid_access_token, headers: { 'Content-Type' => 'application/json' })
  end

  describe '.get' do
    subject { described_class.get(id) }
    let(:body) { file_fixture("#{model_name}/get.json") }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:id) { '1' }

    before { stub_request(:get, url).to_return(body: body, headers: headers) }

    it "returns the #{described_class}" do
      expect(subject).to be_a described_class
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HelpScout::Response do
  describe '#body' do
    subject { described_class.new(response) }
    let(:response) { double('MockFaradayResponse') }
    let(:body) { JSON.parse(file_fixture('response/body.json')) }
    let(:deserialized_body) do
      {
        items: [{ created_at: '2018-04-17' }]
      }
    end

    before do
      expect(response).to receive(:body).and_return(body)
    end

    it 'returns the deserialized body' do
      expect(subject.body).to eq deserialized_body
    end
  end
end

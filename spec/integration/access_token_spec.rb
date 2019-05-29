# frozen_string_literal: true

RSpec.describe Helpscout::API::AccessToken do
  describe '.create' do
    subject { described_class.create }

    it 'returns an AccessToken' do
      expect(subject).to be_a described_class
    end
  end
end

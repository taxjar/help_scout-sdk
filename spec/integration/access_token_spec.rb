# frozen_string_literal: true

RSpec.describe Helpscout::AccessToken do
  describe '.create' do
    subject { described_class.create }

    it 'returns a Helpscout::AccessToken' do
      expect(subject).to be_a Helpscout::AccessToken
    end
  end
end

# frozen_string_literal: true

RSpec.describe Helpscout::AccessToken do
  describe '.create' do
    subject { described_class.create }

    it 'returns a Helpscout::AccessToken' do
      expect(subject).to be_a Helpscout::AccessToken
    end
  end

  describe '.update' do
    let(:new_token_params) do
      {
        access_token: 'foo',
        expires_in: 7200
      }
    end

    subject { described_class.update(new_token_params) }

    it 'returns a Helpscout::AccessToken' do
      expect(subject).to be_a Helpscout::AccessToken
    end
  end
end

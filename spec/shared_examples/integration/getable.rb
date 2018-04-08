# frozen_string_literal: true

RSpec.shared_examples 'getable integration' do
  describe '.get' do
    subject { described_class.get(id) }

    it "returns a #{described_class}" do
      VCR.use_cassette("#{model_name}/get", record: :once) do
        expect(subject).to be_a described_class
      end
    end
  end
end

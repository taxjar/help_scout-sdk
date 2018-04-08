# frozen_string_literal: true

RSpec.shared_examples 'listable integration' do
  describe '.list' do
    subject { described_class.list }

    it "returns an Array of #{described_class} objects" do
      VCR.use_cassette("#{model_name}/list", record: :once) do
        expect(subject).to be_a Array
        expect(subject).to all(be_a(described_class))
      end
    end
  end
end

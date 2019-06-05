# frozen_string_literal: true

RSpec.describe HelpScout::Thread do
  let(:conversation_id) { ENV.fetch('TEST_CONVERSATION_ID') }

  describe '.list' do
    subject { described_class.list(conversation_id) }

    it "returns an Array of #{described_class} objects" do
      expect(subject).to be_a Array
      expect(subject).to all(be_a(described_class))
    end
  end
end

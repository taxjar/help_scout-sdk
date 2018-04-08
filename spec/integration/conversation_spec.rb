RSpec.describe Helpscout::Conversation do
  describe '.list' do
    subject { described_class.list }

    it 'returns an Array of Mailboxes' do
      VCR.use_cassette('conversation/list', record: :once) do
        expect(subject).to be_a Array
        expect(subject).to all(be_a(Helpscout::Conversation))
      end
    end
  end
end

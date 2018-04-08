RSpec.describe Helpscout::Mailbox do
  let(:id) { ENV['TEST_MAILBOX_ID'] }

  describe '.get' do
    subject { described_class.get(id) }

    it 'returns a Mailbox' do
      VCR.use_cassette('mailbox/get', record: :once) do
        expect(subject).to be_a Helpscout::Mailbox
      end
    end
  end

  describe '.list' do
    subject { described_class.list }

    it 'returns an Array of Mailboxes' do
      VCR.use_cassette('mailbox/list', record: :once) do
        expect(subject).to be_a Array
        expect(subject).to all(be_a(Helpscout::Mailbox))
        expect(subject.size).to eq 2
      end
    end
  end

  describe '#folders' do
    subject { described_class.get(id).folders }

    it 'returns an Array of Folders' do
      VCR.use_cassette('mailbox/folders', record: :once) do
        expect(subject).to be_a Array
        expect(subject).to all(be_a(Helpscout::Folder))
        expect(subject.size).to eq 7
      end
    end
  end
end

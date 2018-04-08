RSpec.describe Helpscout::Mailbox do
  describe '.get' do
    subject { described_class.get(id) }
    let(:id) { ENV['TEST_MAILBOX_ID'] }

    it 'gets first page' do
      VCR.use_cassette('mailbox/get', record: :once) do
        expect(subject).to be_a Helpscout::Mailbox
      end
    end
  end

  describe '.list' do
    subject { described_class.list }

    it 'gets first page' do
      VCR.use_cassette('mailbox/list', record: :once) do
        expect(subject).to be_a Array
        expect(subject.size).to eq 2
      end
    end
  end
end

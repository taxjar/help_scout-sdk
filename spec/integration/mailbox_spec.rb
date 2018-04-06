RSpec.describe Helpscout::Mailbox do
  describe '.list' do
    subject { described_class.list }

    context 'when page nil' do
      it 'gets first page' do
        VCR.use_cassette('mailbox/page_1', record: :once) do
          expect(subject).to be_a Array
          expect(subject.size).to eq 2
        end
      end
    end
  end
end

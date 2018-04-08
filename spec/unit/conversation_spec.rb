RSpec.describe Helpscout::Conversation do
  describe '.list' do
    subject { described_class.list }
    let(:body) { file_fixture('conversation/list.json') }

    before do
      stub_request(:get, 'https://api.helpscout.net/v1/mailboxes/127439/conversations.json')
        .to_return(body: body, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns an array of Conversations' do
      expect(subject).to be_a Array
      expect(subject).to all(be_a(Helpscout::Conversation))
    end

    context 'when page set' do
      subject { described_class.list(page: 2) }
      let(:body) { file_fixture('conversation/list.json') }

      before do
        stub_request(:get, 'https://api.helpscout.net/v1/mailboxes/127439/conversations.json?page=2')
          .to_return(body: body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'gets second page' do
        subject
      end
    end
  end
end

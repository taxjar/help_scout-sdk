RSpec.describe Helpscout::Mailbox do
  describe '.list' do
    subject { described_class.list }

    context 'when page nil' do
      it 'gets first page' do
        stub_request(:get, 'https://api.helpscout.net/v1/mailboxes.json')
          .to_return(body: { foo: 'bar' }.to_json, headers: {"Content-Type"=> "application/json"})
        subject
      end
    end

    context 'when page set' do
      subject { described_class.list(2) }

      it 'gets second page' do
        stub_request(:get, 'https://api.helpscout.net/v1/mailboxes.json?page=2')
          .to_return(body: { foo: 'bar' }.to_json, headers: {"Content-Type"=> "application/json"})
        subject
      end
    end
  end
end

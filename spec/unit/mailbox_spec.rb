RSpec.describe Helpscout::Mailbox do
  describe '.find' do
    it 'is an alias for .get' do
      expect(described_class.method(:find)).to eq described_class.method(:get)
    end
  end

  describe '.get' do
    subject { described_class.get(id) }
    let(:id) { '1234' }
    let(:body) { file_fixture('mailbox/get.json') }
    let(:item) { JSON.parse(body)['item'] }

    before do
      stub_request(:get, 'https://api.helpscout.net/v1/mailboxes/1234.json')
        .to_return(body: body, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns the Mailbox' do
      expect(subject).to be_a Helpscout::Mailbox
      expect(subject.id).to eq item['id']
      expect(subject.name).to eq item['name']
      expect(subject.slug).to eq item['slug']
      expect(subject.email).to eq item['email']
      expect(subject.created_at).to eq item['createdAt']
      expect(subject.modified_at).to eq item['modifiedAt']
      expect(subject.custom_fields).to eq item['customFields']
    end
  end

  describe '.list' do
    subject { described_class.list }
    let(:body) { file_fixture('mailbox/list.json') }

    before do
      stub_request(:get, 'https://api.helpscout.net/v1/mailboxes.json')
        .to_return(body: body, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns an array of Mailboxes' do
      expect(subject).to be_a Array
      expect(subject).to all(be_a(Helpscout::Mailbox))
    end

    context 'when page set' do
      subject { described_class.list(page: 2) }

      before do
        stub_request(:get, 'https://api.helpscout.net/v1/mailboxes.json?page=2')
          .to_return(body: body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'gets second page' do
        subject
      end
    end
  end

  describe '#folders' do
    subject { described_class.new(mailbox).folders }
    let(:body) { file_fixture('mailbox/folders.json') }
    let(:mailbox) { JSON.parse(file_fixture('mailbox/get.json'))['item'] }

    before do
      stub_request(:get, 'https://api.helpscout.net/v1/mailboxes/1234/folders.json')
        .to_return(body: body, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns an Array of Folders' do
      expect(subject).to be_a Array
      expect(subject).to all(be_a(Helpscout::Folder))
    end
  end
end

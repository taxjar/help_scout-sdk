# frozen_string_literal: true

RSpec.shared_examples 'getable unit' do |url|
  describe '.find' do
    it 'is an alias for .get' do
      expect(described_class.method(:find)).to eq described_class.method(:get)
    end
  end

  describe '.get' do
    subject { described_class.get(id) }
    let(:body) { file_fixture("#{model_name}/get.json") }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:id) { '1234' }
    let(:item) { JSON.parse(body)['item'] }

    before { stub_request(:get, url).to_return(body: body, headers: headers) }

    it 'returns the Mailbox' do
      expect(subject).to be_a described_class
      expect(subject.as_json.delete_if { |_, v| v.nil? }).to eq item

      # expect(subject.id).to eq item['id']
      # expect(subject.name).to eq item['name']
      # expect(subject.slug).to eq item['slug']
      # expect(subject.email).to eq item['email']
      # expect(subject.created_at).to eq item['createdAt']
      # expect(subject.modified_at).to eq item['modifiedAt']
      # expect(subject.custom_fields).to eq item['customFields']

      # attributes.each do |attribute|
      #   expect(subject.send(attribute)).to eq item[attribute_jsonify(attribute)]
      # end
    end
  end
end

# TODO: Remove
# def attribute_jsonify(attribute)
#   attribute.to_s
# end

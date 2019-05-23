# frozen_string_literal: true

RSpec.shared_examples 'listable unit' do |url|
  describe '.list' do
    subject { described_class.list }
    let(:body) { file_fixture("#{model_name}/list.json") }
    let(:headers) { { 'Content-Type' => 'application/json' } }

    before { stub_request(:get, url).to_return(body: body, headers: headers) }

    it "returns an array of #{described_class} objects" do
      expect(subject).to be_a Array
      expect(subject).to all(be_a(described_class))
    end

    context 'when page set' do
      subject { described_class.list(page: 2) }
      let(:body) { file_fixture("#{model_name}/list.json") }

      before do
        path = url.include?('?') ? "#{url}&page=2" : "#{url}?page=2"
        stub_request(:get, path).to_return(body: body, headers: headers)
      end

      it 'gets second page' do
        subject
      end
    end
  end
end

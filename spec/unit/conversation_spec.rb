# frozen_string_literal: true

require 'shared_examples/unit/getable'
require 'shared_examples/unit/listable'

RSpec.describe Helpscout::Conversation do
  include_examples 'getable unit', 'https://api.helpscout.net/v2/conversations/1'
  include_examples 'listable unit', "https://api.helpscout.net/v2/conversations?mailbox=#{Helpscout.default_mailbox}"

  let(:conversation) { described_class.new(params) }

  describe '.create' do
    subject { described_class.create(params) }
    let(:params) { { subject: 'Hello World' } }
    let(:resource_id) { '123' }
    let(:location) { "https://api.helpscout.net/v2/conversations/#{resource_id}" }

    before do
      stub_request(:post, 'https://api.helpscout.net/v2/conversations').
        with(body: params.to_json).
        to_return(
          status: 201,
          headers: {
            'Location' => location,
            'Resource-ID' => resource_id
          }
        )
    end

    it 'returns the location of the conversation' do
      expect(subject).to eq location
    end
  end

  describe '#update' do
    let(:id) { "123" }
    let(:params) do
      {
        id: id,
        _links: {
          self: { href: "https://api.helpscout.net/v2/conversations/#{id}" }
        }
      }
    end
    let(:new_subject) { "A New Subject" }
    let(:update_params) do
      {
        "op": "replace",
        "path": "/subject",
        "value": new_subject
      }
    end

    subject { conversation.update(*update_params.values) }

    before do
      stub_request(:patch, "https://api.helpscout.net/v2/conversations/#{id}")
        .with(body: update_params.to_json)
        .to_return(status: 204)
    end

    it "returns true" do
      expect(subject).to be true
    end
  end

  describe '#update_tags' do
    let(:id) { "123" }
    let(:params) do
      {
        id: id,
        _links: {
          self: { href: "https://api.helpscout.net/v2/conversations/#{id}" }
        }
      }
    end
    let(:tags) { %w[vip pro] }

    before do
      stub_request(:put, "https://api.helpscout.net/v2/conversations/#{id}/tags")
        .with(body: { tags: tags }.to_json)
        .to_return(status: 204)
    end

    subject { conversation.update_tags(tags) }

    it "returns true" do
      expect(subject).to be true
    end
  end
end

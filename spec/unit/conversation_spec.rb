# frozen_string_literal: true

require 'shared_examples/unit/getable'
require 'shared_examples/unit/listable'

RSpec.describe Helpscout::Conversation do
  include_examples 'getable unit', 'https://api.helpscout.net/v2/conversations/1'
  include_examples 'listable unit', "https://api.helpscout.net/v2/conversations?mailbox=#{Helpscout.default_mailbox}"

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

    subject { described_class.new(params).update(*update_params.values) }

    before do
      stub_request(:patch, "https://api.helpscout.net/v2/conversations/#{id}").
        with(body: update_params.to_json).
        to_return(status: 204)
    end

    it "returns true" do
      expect(subject).to be true
    end
  end
end

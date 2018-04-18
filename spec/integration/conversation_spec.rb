# frozen_string_literal: true

require 'shared_examples/integration/getable'
require 'shared_examples/integration/listable'

RSpec.describe Helpscout::Conversation do
  let(:id) { ENV.fetch('TEST_CONVERSATION_ID') }
  let(:customer_email) { ENV.fetch('TEST_CUSTOMER_EMAIL') }
  let(:user_email) { ENV.fetch('TEST_USER_EMAIL') }
  let(:user_id) { ENV.fetch('TEST_USER_ID') }

  include_examples 'getable integration'
  include_examples 'listable integration'

  describe '.create' do
    subject { described_class.create(params) }
    let(:params) do
      {
        customer: Helpscout::Person.new(email: customer_email),
        subject: 'Hello World!',
        mailbox: Helpscout::MailboxRef.new(id: Helpscout.default_mailbox),
        threads: [thread]
      }
    end
    let(:thread) do
      Helpscout::Thread.new(
        type: 'message',
        created_by: Helpscout::Person.new(type: 'user', id: user_id),
        body: "Hello World, this is #{user_email}."
      )
    end

    it "returns an empty #{described_class} with id" do
      VCR.use_cassette('conversation/create', record: :once) do
        expect(subject).to eq 'https://api.helpscout.net/v1/conversations/558068488.json'
      end
    end
  end

  describe '#update' do
    let(:params) { { tags: tags } }
    let(:tags) { ['integration_spec'] }

    it 'updates the conversations tags' do
      VCR.use_cassette('conversation/update', record: :once) do
        expect(described_class.get(id).tags).not_to eq tags
        expect(described_class.get(id).update(params)).to eq true
        expect(described_class.get(id).tags).to eq tags
      end
    end
  end
end

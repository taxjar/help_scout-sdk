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
        type: "email",
        customer: { email: customer_email },
        subject: 'Hello World!',
        mailbox_id: Helpscout.default_mailbox,
        status: "active",
        threads: [thread]
      }
    end
    let(:thread) do
      {
        type: "chat",
        customer: { email: customer_email },
        text: "A test thread."
      }
    end

    it "returns an empty #{described_class} with id" do
      VCR.use_cassette('conversation/create', record: :once) do
        expect(subject).to eq "https://api.helpscout.net/v2/conversations/859894041"
      end
    end
  end

  describe '#update' do
    let(:params) { { tags: tags } }
    let(:tags) { ['integration_spec'] }

    it "updates the conversation's subject" do
      VCR.use_cassette("conversation/update", record: :once) do
        conversation = described_class.get(id)
        original_subject = conversation.subject
        update_params = {
          op: "replace",
          path: "/subject",
          value: original_subject.reverse
        }

        expect(conversation.update(*update_params.values)).to be true
        new_subject = described_class.get(id).subject

        expect(new_subject).to eq(update_params[:value])
      end
    end
  end
end

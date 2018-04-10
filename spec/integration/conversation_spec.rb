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

    # it "returns an empty #{described_class} with id" do
    #   VCR.use_cassette("#{model_name}/create", record: :once) do
    #     expect(subject).to be_a described_class
    #     expect(subject.id).to be
    #   end
    # end
  end
end

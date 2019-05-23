# frozen_string_literal: true

require 'shared_examples/integration/getable'
require 'shared_examples/integration/listable'

RSpec.describe HelpScout::Conversation do
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
        type: 'email',
        customer: { email: customer_email },
        subject: 'Hello World!',
        mailbox_id: HelpScout.default_mailbox,
        status: 'active',
        threads: [thread]
      }
    end
    let(:thread) do
      {
        type: 'chat',
        customer: { email: customer_email },
        text: 'A test thread.'
      }
    end

    it "returns an empty #{described_class} with id" do
      VCR.use_cassette('conversation/create', record: :once) do
        expect(subject).to eq 'https://api.helpscout.net/v2/conversations/859894041'
      end
    end
  end

  describe '#update' do
    it "updates the conversation's subject" do
      VCR.use_cassette('conversation/update', record: :once) do
        conversation = described_class.get(id)
        original_subject = conversation.subject
        update_params = {
          op: 'replace',
          path: '/subject',
          value: original_subject.reverse
        }

        expect(conversation.update(*update_params.values)).to be true
        new_subject = described_class.get(id).subject

        expect(new_subject).to eq(update_params[:value])
      end
    end
  end

  describe '#update_tags' do
    let(:conversation) { described_class.get(id) }

    subject { conversation.update_tags(tags) }

    context "with an array of tags" do
      let!(:initial_tags) do
        VCR.use_cassette("conversation/update_tags/with_tags_initial", record: :once) do
          tag_array(conversation.tags)
        end
      end
      let(:tags) do
        # We reverse any current tags to handle the case where the conversation
        # already has the hard-coded tags applied. We keep the hardcoded tags
        # in case the conversation has no initial tags.
        (initial_tags + initial_tags.map(&:reverse) + %w[vip pro]).uniq
      end

      it "replaces the conversation's tags" do
        VCR.use_cassette("conversation/update_tags/with_tags", record: :once) do
          expect(tags).not_to match_array(initial_tags)

          subject
          new_tags = tag_array(described_class.get(conversation.id).tags)

          expect(new_tags).to match_array(tags)
        end
      end
    end

    context "with an empty array" do
      let(:tags) { [] }

      it "clears the conversation's tags" do
        VCR.use_cassette("conversation/update_tags/with_empty", record: :once) do
          initial_tags = tag_array(conversation.tags)
          expect(initial_tags).not_to be_empty

          subject
          new_tags = tag_array(described_class.get(conversation.id).tags)

          expect(new_tags).to be_empty
        end
      end
    end

    context "with no arguments" do
      let(:tags) { nil }

      it "clears the conversation's tags" do
        VCR.use_cassette("conversation/update_tags/with_nil", record: :once) do
          subject
          new_tags = tag_array(described_class.get(conversation.id).tags)

          expect(new_tags).to be_empty
        end
      end
    end

    def tag_array(tags_json)
      tags_json.map { |tag| tag[:tag] }
    end
  end
end

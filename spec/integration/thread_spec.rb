# frozen_string_literal: true

RSpec.describe HelpScout::Thread do
  let(:conversation_id) { ENV.fetch('TEST_CONVERSATION_ID') }
  let(:thread_id) { ENV.fetch('TEST_THREAD_ID')}

  describe '.get' do 
    it "returns a HelpScout::Thread given a conversation_id and thread_id" do 
      thread = described_class.get(conversation_id, thread_id)

      expect(thread).to be_a(described_class)
    end
  end

  describe '.list' do
    subject { described_class.list(conversation_id) }

    it "returns an Array of #{described_class} objects" do
      expect(subject).to be_a Array
      expect(subject).to all(be_a(described_class))
    end
  end

  describe '.create' do
    subject { described_class.create(conversation_id, thread_type, params)}
    let(:thread_type) { "notes" }
    let(:params) do
      {
        text: "Hello, note!"
      }
    end

    it 'creates a new thread on a given conversation' do
      expect(subject.success?).to eq(true)
    end
  end

  describe '#update' do
    it "updates a given thread's text on a conversation" do
      thread = described_class.get(conversation_id, thread_id) 
      original_body = thread.body
      update_params = {
        op: 'replace',
        path: '/text',
        value: original_body.reverse
      }

      expect(thread.update(*update_params.values)).to be true
      new_body = described_class.get(conversation_id, thread_id).body
      expect(new_body).to eq(update_params[:value])
    end
  end
end

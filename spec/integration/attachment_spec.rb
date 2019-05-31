# frozen_string_literal: true

# require 'base64'

RSpec.describe HelpScout::Attachment do
  describe '.create' do
    let(:conversation_id) { ENV.fetch('TEST_CONVERSATION_ID') }
    let(:thread_id) { ENV.fetch('TEST_THREAD_ID') }
    let(:attachment_file) { 'attachment/file.txt' }

    let(:params) do
      {
        file_name: File.basename(attachment_file),
        mime_type: 'file/txt',
        data: Base64.strict_encode64(file_fixture(attachment_file))
      }
    end

    subject { described_class.create(conversation_id, thread_id, params) }

    it 'creates an attachment on the thread' do
      expect(subject).to be true
    end
  end
end

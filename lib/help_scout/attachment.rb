# frozen_string_literal: true

module HelpScout
  class Attachment < HelpScout::Base
    BASE_PATH = 'conversations/%<CONVERSATION_ID>/threads/%<THREAD_ID>/attachments'

    class << self
      def create(conversation_id, thread_id, params)
        HelpScout.api.post(create_path(conversation_id, thread_id), HelpScout::Util.camelize_keys(params))
        true
      end

      private

      def create_path(conversation_id, thread_id)
        replacements = {
          '%<CONVERSATION_ID>' => conversation_id,
          '%<THREAD_ID>' => thread_id
        }

        HelpScout::Util.parse_path(BASE_PATH, replacements)
      end
    end
  end
end

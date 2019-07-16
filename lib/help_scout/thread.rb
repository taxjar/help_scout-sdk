# frozen_string_literal: true

module HelpScout
  class Thread < HelpScout::Base
    class << self
      def create(conversation_id, thread_type, params)
        HelpScout.api.post(
          create_path(conversation_id, thread_type),
          HelpScout::Util.camelize_keys(params)
        )
        true
      end

      def list(conversation_id, page: nil)
        HelpScout.api.get(
          list_path(conversation_id), page: page
        ).embedded_list.map { |details| new details.merge(conversation_id: conversation_id) }
      end

      def get(conversation_id, thread_id)
        threads = list(conversation_id)
        threads.find { |thread| thread.id == thread_id }
      end

      private

      def create_path(conversation_id, thread_type)
        "conversations/#{conversation_id}/#{thread_type}"
      end

      def list_path(conversation_id)
        "conversations/#{conversation_id}/threads"
      end
    end

    BASIC_ATTRIBUTES = %i[
      id
      assigned_to
      status
      state
      action
      body
      source
      customer
      created_by
      saved_reply_id
      type
      to
      cc
      bcc
      created_at
      opened_at
      attachments
      conversation_id
    ].freeze

    attr_accessor(*BASIC_ATTRIBUTES)
    attr_reader :hrefs

    def initialize(params)
      BASIC_ATTRIBUTES.each do |attribute|
        next unless params[attribute]

        instance_variable_set("@#{attribute}", params[attribute])
      end

      @hrefs = HelpScout::Util.map_links(params.fetch(:_links, []))
    end

    def conversation
      @_conversation ||= HelpScout::Conversation.get(conversation_id)
    end

    def update(operation, path, value = nil)
      update_path = "conversations/#{conversation_id}/threads/#{id}"
      HelpScout.api.patch(update_path, op: operation, path: path, value: value)
      true
    end
  end
end

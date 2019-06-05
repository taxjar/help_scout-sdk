# frozen_string_literal: true

module HelpScout
  class Thread < HelpScout::Base
    class << self
      def list(conversation_id, page: nil)
        HelpScout.api.get(list_path(conversation_id), page: page).embedded_list.map { |details| new details }
      end

      private

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
  end
end

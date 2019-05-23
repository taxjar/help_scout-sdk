# frozen_string_literal: true

module Helpscout
  class Folder < Helpscout::Base
    ROUTE = 'v2/mailboxes/%<MAILBOX_ID>/folders/'

    class << self
      def list(mailbox_id: Helpscout.default_mailbox, page: nil)
        resp = Helpscout.api.get(list_path(mailbox_id), page: page)

        resp.embedded[:folders].map { |folder| new folder }
      end

      private

      def list_path(mailbox_id)
        ROUTE.sub(/\%<MAILBOX_ID>/, mailbox_id.to_s)
      end
    end

    BASIC_ATTRIBUTES = %i[
      id
      name
      type
      user_id
      total_count
      active_count
      updated_at
    ].freeze
    attr_reader(*BASIC_ATTRIBUTES)

    def initialize(params)
      BASIC_ATTRIBUTES.each do |attribute|
        next unless params[attribute]

        instance_variable_set("@#{attribute}", params[attribute])
      end
    end
  end
end

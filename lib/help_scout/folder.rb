# frozen_string_literal: true

module HelpScout
  class Folder < HelpScout::Base
    extend Listable

    class << self
      private

      def base_path
        'mailboxes/%<MAILBOX_ID>/folders/'
      end

      def list_path(mailbox_id)
        replacements = {
          '%<MAILBOX_ID>' => mailbox_id
        }

        HelpScout::Util.parse_path(base_path, replacements)
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

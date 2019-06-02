# frozen_string_literal: true

module HelpScout
  class Mailbox < HelpScout::Base
    BASE_PATH = 'mailboxes'

    extend Getable
    extend Listable

    class << self
      private

      def embed_key
        :mailboxes
      end

      def get_path(id)
        "#{BASE_PATH}/#{id}"
      end

      def list_path(_)
        BASE_PATH
      end

      def parse_item(response)
        response.body
      end
    end

    BASIC_ATTRIBUTES = %i[
      id
      name
      slug
      email
      created_at
      updated_at
    ].freeze
    attr_reader(*BASIC_ATTRIBUTES)
    attr_reader :hrefs

    def initialize(params)
      BASIC_ATTRIBUTES.each do |attribute|
        next unless params[attribute]

        instance_variable_set("@#{attribute}", params[attribute])
      end

      @hrefs = HelpScout::Util.map_links(params[:_links])
    end

    # TODO: def conversations
    # end

    def fields
      @fields ||= HelpScout.api.get(fields_path).embedded[:fields]
    end
    alias custom_fields fields

    def folders
      @folders ||= HelpScout::Folder.list(id: id)
    end

    private

    def fields_path
      hrefs[:fields]
    end
  end
end

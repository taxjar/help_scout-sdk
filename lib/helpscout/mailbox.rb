# frozen_string_literal: true

module Helpscout
  class Mailbox < Helpscout::Base
    ROUTE = 'v2/mailboxes'

    extend Getable

    class << self
      # TODO: Make sure folders is init'd correctly when lazy loaded
      def list(page: nil)
        Helpscout.api.get(list_path, page: page).embedded[:mailboxes].map { |item| new item }
      end

      private

      def get_path(id)
        "#{ROUTE}/#{id}"
      end

      def list_path
        ROUTE.to_s
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

      @hrefs = Helpscout::Util.map_links(params[:_links])
    end

    # TODO: def conversations
    # end

    def fields
      @fields ||= Helpscout.api.get(fields_path).embedded[:fields]
    end
    alias custom_fields fields

    def folders
      @folders ||= Helpscout::Folder.list(mailbox_id: id)
    end

    private

    def fields_path
      hrefs[:fields]
    end
  end
end

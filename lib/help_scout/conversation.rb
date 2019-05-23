# frozen_string_literal: true

module HelpScout
  class Conversation < HelpScout::Base
    BASE_URL = "v2/conversations"

    extend Getable

    class << self
      def list(mailbox_id: HelpScout.default_mailbox, page: nil)
        resp = HelpScout.api.get(list_path(mailbox_id), page: page)

        resp.embedded[:conversations].map { |conversation| new conversation }
      end

      # TODO: Add the below methods
      # def list_for_customer
      # end
      #
      # def list_for_folder
      # end
      #
      # def list_for_user
      # end

      def create(params)
        resp = HelpScout.api.post(create_path, HelpScout::Util.camelize_keys(params))

        resp.location
      end

      private

      def create_path
        BASE_URL
      end

      def get_path(id)
        "#{BASE_URL}/#{id}"
      end

      def list_path(mailbox_id)
        "#{BASE_URL}?mailbox=#{mailbox_id}"
      end

      def parse_item(response)
        response.body
      end
    end

    BASIC_ATTRIBUTES = %i[
      id
      number
      threads
      type
      folder_id
      status
      state
      subject
      preview
      mailbox_id
      assignee
      created_by
      created_at
      closed_by
      closed_at
      user_updated_at
      customer_waiting_since
      source
      tags
      cc
      bcc
      primary_customer
      custom_fields
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

    # TODO: populate with data when id is present
    # def hydrate
    # end

    # TODO: ?
    # def parse_customer(customer)
    #   customer.is_a?(HelpScout::Person) ? customer : build_person(customer)
    # end

    def update(operation, path, value = nil)
      update_path = URI.parse(hrefs[:self]).path
      HelpScout.api.patch(update_path, op: operation, path: path, value: value)
      true
    end
  end
end

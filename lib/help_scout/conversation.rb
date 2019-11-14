# frozen_string_literal: true

module HelpScout
  class Conversation < HelpScout::Base
    extend Getable
    extend Listable

    class << self
      def create(params)
        response = HelpScout.api.post(create_path, HelpScout::Util.camelize_keys(params))
        response.location
      end

      private

      def create_path
        base_path
      end

      def list_path(mailbox_id)
        "#{base_path}?mailbox=#{mailbox_id}"
      end
    end

    BASIC_ATTRIBUTES = %i[
      id
      number
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
      threads
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

    def populated_threads
      @_populated_threads ||= HelpScout::Thread.list(id)
    end

    def update(operation, path, value = nil)
      update_path = URI.parse(hrefs[:self]).path
      HelpScout.api.patch(update_path, op: operation, path: path, value: value)
      true
    end

    def update_tags(new_tags = nil)
      new_tags ||= []
      tags_path = URI.parse(hrefs[:self]).path + '/tags'
      HelpScout.api.put(tags_path, tags: new_tags)
      true
    end
  end
end

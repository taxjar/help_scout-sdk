# frozen_string_literal: true

module HelpScout
  class Mailbox < HelpScout::Base
    extend Getable
    extend Listable

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

    def fields
      @_fields ||= HelpScout.api.get(fields_path).embedded[:fields]
    end

    def folders
      @_folders ||= HelpScout::Folder.list(id: id)
    end

    private

    def fields_path
      hrefs[:fields]
    end
  end
end

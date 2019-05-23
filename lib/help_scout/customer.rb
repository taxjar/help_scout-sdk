# frozen_string_literal: true

module HelpScout
  class Customer < HelpScout::Base
    BASE_URL = "v2/customers"

    extend Getable

    class << self
      def get_path(id)
        "#{BASE_URL}/#{id}"
      end

      def list(page: nil)
        resp = HelpScout.api.get(list_path, page: page)

        resp.embedded[:customers].map { |details| new(details) }
      end

      def list_path
        BASE_URL
      end

      def parse_item(response)
        response.body
      end
    end

    BASIC_ATTRIBUTES = %i[
      first_name
      last_name
      photo_url
      job_title
      photo_type
      background
      location
      created_at
      updated_at
      organization
      gender
      age
      id
    ].freeze
    EMBEDDED_ATTRIBUTES = %i[
      addresses
      chats
      emails
      phones
      social_profiles
      websites
    ].freeze
    attr_reader(*(BASIC_ATTRIBUTES + EMBEDDED_ATTRIBUTES))
    attr_reader :hrefs

    def initialize(params = {})
      BASIC_ATTRIBUTES.each do |attribute|
        next unless params[attribute]

        instance_variable_set("@#{attribute}", params[attribute])
      end

      embedded_params = params.fetch(:_embedded, {})
      EMBEDDED_ATTRIBUTES.each do |attribute|
        next unless embedded_params[attribute]

        instance_variable_set("@#{attribute}", embedded_params[attribute])
      end

      @hrefs = HelpScout::Util.map_links(params[:_links])
    end
  end
end

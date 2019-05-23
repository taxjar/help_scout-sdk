# frozen_string_literal: true

module HelpScout
  class User < HelpScout::Base
    BASE_URL = 'v2/users'

    extend Getable

    class << self
      def list(page: nil)
        resp = HelpScout.api.get(list_path, page: page)

        resp.embedded[:users].map { |user| new(user) }
      end

      private

      def get_path(id)
        "#{BASE_URL}/#{id}"
      end

      def list_path
        BASE_URL
      end

      def parse_item(response)
        response.body
      end
    end

    BASIC_ATTRIBUTES = %i[
      id
      first_name
      last_name
      email
      created_at
      updated_at
      role
      timezone
      type
      photoUrl
    ].freeze

    attr_reader(*BASIC_ATTRIBUTES)
    attr_reader :hrefs

    def initialize(params = {})
      BASIC_ATTRIBUTES.each do |attribute|
        next unless params[attribute]

        instance_variable_set("@#{attribute}", params[attribute])
      end

      @hrefs = HelpScout::Util.map_links(params[:_links])
    end
  end
end

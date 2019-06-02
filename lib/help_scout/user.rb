# frozen_string_literal: true

module HelpScout
  class User < HelpScout::Base
    BASE_PATH = 'users'

    extend Getable
    extend Listable

    class << self
      private

      def get_path(id)
        "#{BASE_PATH}/#{id}"
      end

      def embed_key
        :users
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

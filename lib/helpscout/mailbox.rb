module Helpscout
  class Mailbox
    ROUTE = 'mailboxes'.freeze

    class << self
      def get(id)
        new Helpscout.api.get(get_path(id))['item']
      end
      alias find get

      def get_path(id)
        "#{ROUTE}/#{id}.json"
      end

      def list(page = nil)
        Helpscout.api.get(list_path, page: page)['items'].map { |item| new item }
      end

      def list_path
        "#{ROUTE}.json"
      end
    end

    def initialize(params)
      @id = params['id']
      @name = params['name']
      @slug = params['slug']
      @email = params['email']
      @created_at = params['createdAt']
      @modified_at = params['modifiedAt']
      @custom_fields = params['custom_fields']
    end

    attr_reader :id, :name, :slug, :email, :created_at, :modified_at,
                :custom_fields
  end
end

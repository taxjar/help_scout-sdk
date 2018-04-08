module Helpscout
  class Mailbox
    ROUTE = 'mailboxes'.freeze

    class << self
      def get(id)
        new Helpscout.api.get(get_path(id))['item']
      end
      alias find get

      def list(page = nil)
        Helpscout.api.get(list_path, page: page)['items'].map { |item| new item }
      end

      private

      def get_path(id)
        "#{ROUTE}/#{id}.json"
      end

      def list_path
        "#{ROUTE}.json"
      end
    end

    attr_reader :id, :name, :slug, :email, :created_at, :modified_at,
                :custom_fields

    def initialize(params)
      @id = params['id']
      @name = params['name']
      @slug = params['slug']
      @email = params['email']
      @created_at = params['createdAt']
      @modified_at = params['modifiedAt']
      @custom_fields = params['custom_fields']
    end

    def folders
      Helpscout.api.get(folders_path)['items'].map { |item| new_folder(item) }
    end

    private

    def folders_path
      "#{ROUTE}/#{id}/folders.json"
    end

    def new_folder(params)
      Helpscout::Folder.new(params)
    end
  end
end

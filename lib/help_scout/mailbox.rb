# frozen_string_literal: true

module HelpScout
  class Mailbox < HelpScout::Base
    ROUTE = 'mailboxes'

    extend Getable

    class << self
      # TODO: Make sure folders is init'd correctly when lazy loaded
      def list(page: nil)
        HelpScout.api.get(list_path, page: page).items.map { |item| new item }
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
      @id = params[:id]
      @name = params[:name]
      @slug = params[:slug]
      @email = params[:email]
      @created_at = params[:created_at]
      @modified_at = params[:modified_at]
      @custom_fields = params[:custom_fields]
      @folders = build_folders(params[:folders])
    end

    # TODO: def conversations
    # end

    def folders
      @folders ||= from_json(HelpScout.api.get(folders_path)[:items])
    end

    private

    def build_folder(params)
      return unless params

      HelpScout::Folder.new(params)
    end

    def build_folders(items)
      items&.map { |item| build_folder(item) }
    end

    def folders_path
      "#{ROUTE}/#{id}/folders.json"
    end
  end
end

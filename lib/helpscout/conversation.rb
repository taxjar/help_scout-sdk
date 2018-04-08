# frozen_string_literal: true

module Helpscout
  class Conversation < Helpscout::Base
    extend Getable

    class << self
      def list(mailbox_id: Helpscout.default_mailbox, page: nil)
        Helpscout.api.get(list_path(mailbox_id), page: page)['items']
                 .map { |item| new item }
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

      private

      def get_path(id)
        "conversations/#{id}.json"
      end

      def list_path(mailbox_id)
        "mailboxes/#{mailbox_id}/conversations.json"
      end
    end

    attr_reader :id, :type, :folder_id, :is_draft, :number, :owner, :mailbox,
                :customer, :thread_count, :status, :subject, :preview,
                :created_by, :created_at, :modified_at, :closed_at, :closed_by,
                :source, :cc, :bcc, :tags

    def initialize(params)
      @id = params['id']
      @type = params['type'] # TODO: Sub-classes
      @folder_id = params['folderId']
      @is_draft = params['isDraft']
      @number = params['number']
      @owner = nil # Person
      @mailbox = nil # MailboxRef
      @customer = nil # Person
      @thread_count = params['threadCount']
      @status = params['status']
      @subject = params['subject']
      @preview = params['preview']
      @created_by = nil # Person
      @created_at = params['createdAt']
      @modified_at = params['modifiedAt']
      @closed_at = params['closedAt']
      @closed_by = nil # Person
      @source = params['source']
      @cc = params['cc']
      @bcc = params['bcc']
      @tags = params['tags']
      # @threads = build_threads(params['threads'])
    end
  end
end

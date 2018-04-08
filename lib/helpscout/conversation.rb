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
      @owner = build_person(params['owner'])
      @mailbox = build_mailbox_ref(params['mailbox'])
      @customer = build_person(params['customer'])
      @thread_count = params['threadCount']
      @status = params['status']
      @subject = params['subject']
      @preview = params['preview']
      @created_by = build_person(params['createdBy'])
      @created_at = params['createdAt']
      @modified_at = params['modifiedAt']
      @user_modified_at = params['userModifiedAt']
      @closed_at = params['closedAt']
      @closed_by = build_person(params['closedBy'])
      @source = params['source']
      @cc = params['cc']
      @bcc = params['bcc']
      @tags = params['tags']
      # @threads = build_threads(params['threads'])
    end

    private

    def build_mailbox_ref(params)
      return unless params
      Helpscout::MailboxRef.new(params)
    end

    def build_person(params)
      return unless params
      Helpscout::Person.new(params)
    end
  end
end

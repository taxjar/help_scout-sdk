# frozen_string_literal: true

module Helpscout
  class Conversation < Helpscout::Base
    SAVE_PATH = 'conversations.json'

    extend Getable

    class << self
      def list(mailbox_id: Helpscout.default_mailbox, page: nil)
        Helpscout.api.get(list_path(mailbox_id), page: page).items.map { |item| new item }
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

      def create(params)
        new(params).save.location
      end

      private

      def get_path(id)
        "conversations/#{id}.json"
      end

      def list_path(mailbox_id)
        "mailboxes/#{mailbox_id}/conversations.json"
      end
    end

    attr_accessor :id, :type, :folder_id, :is_draft, :number, :owner, :mailbox,
                  :customer, :thread_count, :status, :subject, :preview,
                  :created_by, :created_at, :modified_at, :closed_at, :closed_by,
                  :source, :cc, :bcc, :tags

    def initialize(params) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      @id = params[:id]
      @type = params[:type] # TODO: Sub-classes
      @folder_id = params[:folder_id]
      @is_draft = params[:is_draft]
      @number = params[:number]
      @owner = build_person(params[:owner])
      @mailbox = build_mailbox_ref(params[:mailbox])
      @customer = build_person(params[:customer])
      @thread_count = params[:thread_count]
      @status = params[:status]
      @subject = params[:subject]
      @preview = params[:preview]
      @created_by = build_person(params[:created_by])
      @created_at = params[:created_at]
      @modified_at = params[:modified_at]
      @user_modified_at = params[:user_modified_at]
      @closed_at = params[:closed_at]
      @closed_by = build_person(params[:closed_by])
      @source = params[:source]
      @cc = params[:cc]
      @bcc = params[:bcc]
      @tags = params[:tags]
      @threads = build_threads(params[:threads])
    end

    # TODO: populate with data when id is present
    # def hydate
    # end

    # TODO: ?
    # def parse_customer(customer)
    #   customer.is_a?(Helpscout::Person) ? customer : build_person(customer)
    # end

    def save
      Helpscout.api.post(SAVE_PATH, as_json)
      # TODO: optional hydrate
    end

    def update(params)
      params.each { |k, v| public_send("#{k}=", v) }
      Helpscout.api.put("conversations/#{id}.json", as_json)
      true
    end

    private

    # TODO: DRY
    def build_mailbox_ref(params)
      return unless params
      return params if params.is_a? Helpscout::MailboxRef

      Helpscout::MailboxRef.new(params)
    end

    # TODO: DRY
    def build_person(params)
      return unless params
      return params if params.is_a? Helpscout::Person

      Helpscout::Person.new(params)
    end

    def build_thread(params)
      return unless params
      return params if params.is_a? Helpscout::Thread

      Helpscout::Thread.new(params)
    end

    def build_threads(items)
      items&.map { |item| build_thread(item) }
    end
  end
end

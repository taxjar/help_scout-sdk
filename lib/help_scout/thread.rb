# frozen_string_literal: true

module HelpScout
  class Thread < HelpScout::Base
    extend Listable

    class << self
      private

      def embed_key
        threads
      end

      def list_path(conversation_id)
        "conversations/#{conversation_id}/threads"
      end
    end

    def initialize(params) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      @id = params[:id]
      @assigned_to = build_person(params[:assigned_to])
      @status = params[:status]
      @created_at = params[:created_at]
      @opened_at = params[:opened_at]
      @created_by = build_person(params[:created_by])
      @source = build_source(params[:source])
      @action_type = params[:action_type]
      @action_source_id = params[:action_source_id]
      @type = params[:type]
      @state = params[:state]
      @customer = build_person(params[:customer])
      @from_mailbox = build_mailbox_ref(params[:from_mailbox])
      @body = params[:body]
      @to = params[:to]
      @cc = params[:cc]
      @bcc = params[:bcc]
      @attachments = params[:attachments]
      @saved_reply_id = params[:saved_reply_id]
      @created_by_customer = params[:created_by_customer]
    end

    private

    # TODO: DRY
    def build_mailbox_ref(params)
      return unless params
      return params if params.is_a? HelpScout::MailboxRef

      HelpScout::MailboxRef.new(params)
    end

    # TODO: DRY
    def build_person(params)
      return unless params
      return params if params.is_a? HelpScout::Person

      HelpScout::Person.new(params)
    end

    def build_source(params)
      return unless params
      return params if params.is_a? HelpScout::Source

      HelpScout::Source.new(params)
    end
  end
end

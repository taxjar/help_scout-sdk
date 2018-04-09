# frozen_string_literal: true

module Helpscout
  class Thread < Helpscout::Base
    def initialize(params)
      @id = params['id']
      @assigned_to = build_person(params['assignedTo'])
      @status = params['status']
      @created_at = params['createdAt']
      @opened_at = params['openedAt']
      @created_by = build_person(params['createdBy'])
      @source = build_source(params['source'])
      @action_type = params['actionType']
      @action_source_id = params['actionSourceId']
      @type = params['type']
      @state = params['state']
      @customer = build_person(params['customer'])
      @from_mailbox = build_mailbox_ref(params['fromMailbox'])
      @body = params['body']
      @to = params['to']
      @cc = params['cc']
      @bcc = params['bcc']
      @attachments = params['attachments']
      @saved_reply_id = params['savedReplyId']
      @created_by_customer = params['createdByCustomer']
    end

    private

    # TODO: DRY
    def build_mailbox_ref(params)
      return unless params
      Helpscout::MailboxRef.new(params)
    end

    # TODO: DRY
    def build_person(params)
      return unless params
      Helpscout::Person.new(params)
    end

    def build_source(params)
      return unless params
      Helpscout::Source.new(params)
    end
  end
end

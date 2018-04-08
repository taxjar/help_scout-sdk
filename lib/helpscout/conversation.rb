module Helpscout
  class Conversation
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

      def list_path(mailbox_id)
        "#{route(mailbox_id)}.json"
      end

      def route(id)
        "mailboxes/#{id}/conversations"
      end
    end

    def initialize(params)
    end
  end
end

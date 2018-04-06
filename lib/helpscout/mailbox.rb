module Helpscout
  class Mailbox
    LIST_PATH = 'mailboxes.json'.freeze

    def self.list(page = nil)
      Helpscout.api.get(list_path, page: page).items
    end

    def self.list_path
      LIST_PATH
    end
  end
end

# frozen_string_literal: true

module HelpScout
  module Listable
    def list(id: HelpScout.default_mailbox, page: nil)
      HelpScout.api.get(list_path(id), page: page).embedded_list.map { |e| new e }
    end

    def list_path(_)
      base_path
    end
  end
end

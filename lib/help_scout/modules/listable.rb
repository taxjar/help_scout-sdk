# frozen_string_literal: true

module HelpScout
  module Listable
    def list(id: HelpScout.default_mailbox, page: nil)
      HelpScout.api.get(list_path(id), page: page).embedded[embed_key].map { |e| new e } # TODO: .embedded needed?
    end
  end
end

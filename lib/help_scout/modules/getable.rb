# frozen_string_literal: true

module HelpScout
  module Getable
    def get(id)
      new parse_item(HelpScout.api.get(get_path(id)))
    end
    alias find get
  end
end

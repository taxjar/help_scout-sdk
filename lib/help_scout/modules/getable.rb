# frozen_string_literal: true

module HelpScout
  module Getable
    def get(id)
      new HelpScout.api.get(get_path(id)).item
    end
    alias find get
  end
end

# frozen_string_literal: true

module HelpScout
  module Getable
    def get(id)
      new parse_item(HelpScout.api.get(get_path(id)))
    end

    def get_path(id)
      "#{base_path}/#{id}"
    end
  end
end

# frozen_string_literal: true

module Helpscout
  module Getable
    def get(id)
      new parse_item(Helpscout.api.get(get_path(id)))
    end
    alias find get
  end
end

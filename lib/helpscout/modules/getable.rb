module Helpscout
  module Getable
    def get(id)
      new Helpscout.api.get(get_path(id))['item']
    end
    alias find get
  end
end

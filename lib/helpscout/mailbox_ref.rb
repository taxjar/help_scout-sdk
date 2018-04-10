# frozen_string_literal: true

module Helpscout
  class MailboxRef < Helpscout::Base
    def initialize(params)
      @id = params[:id]
      @name = params[:name]
    end
  end
end

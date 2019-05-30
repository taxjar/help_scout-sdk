# frozen_string_literal: true

module HelpScout
  class MailboxRef < HelpScout::Base
    def initialize(params)
      @id = params[:id]
      @name = params[:name]
    end
  end
end

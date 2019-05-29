# frozen_string_literal: true

module HelpScout
  class Source < HelpScout::Base
    attr_reader :type, :via
    def initialize(params)
      @type = params[:type]
      @via = params[:via]
    end
  end
end

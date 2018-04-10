# frozen_string_literal: true

module Helpscout
  class Source < Helpscout::Base
    attr_reader :type, :via
    def initialize(params)
      @type = params[:type]
      @via = params[:via]
    end
  end
end

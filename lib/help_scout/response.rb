# frozen_string_literal: true

module HelpScout
  class Response
    delegate :headers, to: :response

    attr_reader :response
    def initialize(response)
      @response = response
    end

    def body
      @body ||= response.body.deep_transform_keys { |key| key.to_s.underscore.to_sym }
    end

    def embedded
      body[:_embedded]
    end

    def item
      body[:item]
    end

    def items
      body[:items]
    end

    def location
      headers['location']
    end
  end
end

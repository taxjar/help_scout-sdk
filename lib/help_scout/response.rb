# frozen_string_literal: true

module HelpScout
  class Response
    delegate :headers, :status, :success?, to: :response

    attr_reader :response
    def initialize(response)
      @response = response
    end

    def body
      @body ||= response.body.deep_transform_keys { |key| key.to_s.underscore.to_sym }
    end

    def embedded
      body[:_embedded] # TODO: We should just pluck the internal key here
    end

    def embedded_list
      embedded.values.first
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

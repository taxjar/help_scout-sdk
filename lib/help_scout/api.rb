# frozen_string_literal: true

# TODO: PERFORM_DELIVERIES option
# TODO: Error handling (e.g. HelpScout::Conversation.create(foo: :bar))
# TODO: Clean up with ActiveSupport

module HelpScout
  class API
    class BadRequest < StandardError; end
    class NotAuthorized < StandardError; end
    class NotFound < StandardError; end
    class InternalError < StandardError; end
    class ThrottleLimitReached < StandardError; end

    BASE_URL = 'https://api.helpscout.net/v2/'

    class << self
      def from_json(data)
        deep_underscore(::JSON.parse(data))
      end

      private

      def deep_underscore(hash)
        hash.map do |k, v|
          [
            deep_underscore_key(k),
            deep_underscore_value(v)
          ]
        end.to_h
      end

      def deep_underscore_key(key)
        underscore(key).to_sym
      end

      def deep_underscore_value(value) # rubocop:disable Metrics/MethodLength
        case value
        when Hash
          deep_underscore(value)
        when Array
          if value.any? { |e| e.class < HelpScout::Base }
            value.map { |v| deep_underscore(v) }
          else
            value
          end
        else
          value
        end
      end

      def underscore(string)
        string.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z\d])([A-Z])/, '\1_\2').
          tr('-', '_').
          downcase
      end
    end

    def get(path, params = {})
      handle_response(http_action(:get, path, params))
    end

    def patch(path, params)
      handle_response(http_action(:patch, path, params))
    end

    def post(path, params)
      handle_response(http_action(:post, path, params))
    end

    def put(path, params)
      handle_response(http_action(:put, path, params))
    end

    def reset_connection!
      @client = nil
      client
      true
    end

    private

    def cleansed_params(params)
      params.delete_if { |_, v| v.nil? }
      # params
    end

    def client
      @client ||= Faraday.new(url: BASE_URL) do |conn|
        conn.request :json
        conn.authorization(:Bearer, HelpScout.access_token.token) if HelpScout.access_token
        conn.response(:json, content_type: /\bjson$/)
        conn.adapter(Faraday.default_adapter)
      end
    end

    # rubocop:disable AbcSize
    # rubocop:disable MethodLength
    def handle_response(result)
      case result.status
      when 400
        raise BadRequest, result.body&.dig('validationErrors')
      when 401
        raise NotAuthorized, result.body&.dig('error')
      when 404
        raise NotFound, result.body&.dig('error')
      when 429
        raise ThrottleLimitReached, result.body&.dig('error')
      when 500, 501, 503
        raise InternalError, result.body&.dig('error')
      end

      HelpScout::Response.new(result)
    end
    # rubocop:enable AbcSize
    # rubocop:enable MethodLength

    def http_action(action, path, params)
      client.send(action, path, cleansed_params(params))
    end
  end
end

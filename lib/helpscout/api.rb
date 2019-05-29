# frozen_string_literal: true

# TODO: PERFORM_DELIVERIES option
# TODO: Error handling (e.g. Helpscout::Conversation.create(foo: :bar))
# TODO: Clean up with ActiveSupport

module Helpscout
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
          if value.any? { |e| e.class < Helpscout::Base }
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

    # TODO: Move AccessToken Inside Namespace and move these methods
    attr_writer :access_token
    def initialize
      @access_token = Helpscout.configuration.access_token
    end

    def access_token
      @access_token ||= Helpscout::AccessToken.new(fetch_access_token)
    end

    def fetch_access_token # rubocop:disable Metrics/MethodLength
      params = {
        grant_type: 'client_credentials',
        client_id: Helpscout.app_id,
        client_secret: Helpscout.app_secret
      }

      response = client(skip_authorization: true).post('oauth2/token', params)

      case response.status
      when 429
        raise ThrottleLimitReached, response.body&.dig('error')
      when 500, 501, 503
        raise InternalError, response.body&.dig('error')
      end

      Helpscout::Response.new(response).body
    end

    def get(path, params = {})
      http_action(:get, path, params)
    end

    def patch(path, params)
      http_action(:patch, path, params)
    end

    def post(path, params)
      http_action(:post, path, params)
    end

    def put(path, params)
      http_action(:put, path, params)
    end

    private

    def cleansed_params(params)
      params.delete_if { |_, v| v.nil? }
      # params
    end

    # TODO: Extract into class
    def client(skip_authorization: false)
      Faraday.new(url: BASE_URL) do |conn|
        conn.request :json
        conn.authorization(:Bearer, access_token.value) unless skip_authorization
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
        raise NotAuthorized, result.body&.dig('error_description')
      when 404
        raise NotFound, 'Resource Not Found'
      when 429
        raise ThrottleLimitReached, result.body&.dig('error')
      when 500, 501, 503
        raise InternalError, result.body&.dig('error')
      end

      Helpscout::Response.new(result)
    end
    # rubocop:enable AbcSize
    # rubocop:enable MethodLength

    def http_action(action, path, params)
      response = client.send(action, path, cleansed_params(params))

      if response.status == 401 && Helpscout.configuration.automatically_generate_tokens
        Helpscout::AccessToken.refresh!
        response = client.send(action, path, cleansed_params(params))
      end

      handle_response(response)
    end
  end
end

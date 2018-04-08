# TODO: PERFORM_DELIVERIES option
# TODO: Error handling

module Helpscout
  class API
    class BadRequest < StandardError; end
    class NotAuthorized < StandardError; end
    class NotFound < StandardError; end
    class InternalError < StandardError; end
    class ThrottleLimitReached < StandardError; end

    BASE_URL = 'https://api.helpscout.net/v1/'.freeze

    def get(path, params = {})
      handle_response(http_action(:get, path, params))
    end

    def post(path, params)
      handle_response(http_action(:post, path, params))
    end

    def put(path, params)
      handle_response(http_action(:put, path, params))
    end

    private

    def cleansed_params(params)
      params.delete_if { |_, v| v.nil? }
    end

    def client
      @client ||= Faraday.new(url: BASE_URL) do |conn|
        conn.request :url_encoded
        conn.basic_auth(Helpscout.api_key, 'X')
        conn.response(:json, content_type: /\bjson$/)
        conn.adapter(Faraday.default_adapter)
      end
    end

    def handle_response(result)
      case result.status
      when 400
        raise BadRequest, result.body&.dig('error')
      when 401
        raise NotAuthorized, result.body&.dig('error')
      when 404
        raise NotFound, result.body&.dig('error')
      when 429
        raise ThrottleLimitReached, result.body&.dig('error')
      when 500, 501, 503
        raise InternalError, result.body&.dig('error')
      end

      result.body
    end

    def http_action(action, path, params)
      client.send(action, path, cleansed_params(params))
    end
  end
end

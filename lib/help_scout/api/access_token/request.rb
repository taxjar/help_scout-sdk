# frozen_string_literal: true

module HelpScout
  class API
    class AccessToken
      class Request
        attr_reader :response

        def execute
          @response = request_token
        end

        private

        def request_token
          connection = API::Client.new(authorize: false).connection
          http_response = connection.post('oauth2/token', token_request_params)

          case http_response.status
          when 200 then AccessToken.new(Response.new(http_response).body)
          when 429 then raise API::ThrottleLimitReached, http_response.body&.dig('error')
          else raise API::InternalError, "unexpected response (status #{http_response.status})"
          end
        end

        def token_request_params
          @_token_request_params ||= {
            grant_type: 'client_credentials',
            client_id: HelpScout.app_id,
            client_secret: HelpScout.app_secret
          }
        end
      end
    end
  end
end

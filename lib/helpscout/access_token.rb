# frozen_string_literal: true

module Helpscout
  class AccessToken
    BASE_PATH = 'oauth2/token'

    class << self
      def create # rubocop:disable Metrics/MethodLength
        response = Helpscout.api.post(
          create_path,
          grant_type: 'client_credentials',
          client_id: Helpscout.app_id,
          client_secret: Helpscout.app_secret
        ).body

        Helpscout::AccessToken.new(
          response[:access_token],
          response[:expires_in]
        ).tap do |access_token|
          Helpscout.configure { |c| c.access_token = access_token }
          Helpscout.api.reset_connection!
        end
      end

      private

      def create_path
        BASE_PATH
      end
    end

    attr_reader :expires_in, :token

    def initialize(access_token, token_expires_in)
      @token = access_token
      @expires_in = token_expires_in
    end
  end
end

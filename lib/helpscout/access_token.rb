# frozen_string_literal: true

module Helpscout
  class AccessToken
    class << self
      def create
        response = Helpscout.api.fetch_access_token
        update(response.body)
      end

      def refresh!
        create
      end

      def update(new_token_params)
        new(new_token_params).tap do |access_token|
          Helpscout.configuration.access_token = access_token
          Helpscout.api.access_token = access_token.value
        end
      end
    end

    attr_reader :expires_at, :expires_in, :value

    def initialize(params)
      @value = params[:access_token]
      @expires_in = params[:expires_in]
      @expires_at = Time.now.utc + params[:expires_in]
    end

    def expired?
      Time.now.utc > expires_at
    end
  end
end

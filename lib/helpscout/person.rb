# frozen_string_literal: true

module Helpscout
  class Person < Helpscout::Base
    attr_reader :id, :first_name, :last_name, :email, :phone, :type
    def initialize(params)
      @id = params['id']
      @first_name = params['firstName']
      @last_name = params['lastName']
      @email = params['email']
      @phone = params['phone']
      @type = params['type']
    end
  end
end

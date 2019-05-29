# frozen_string_literal: true

module HelpScout
  class Person < HelpScout::Base
    attr_reader :id, :first_name, :last_name, :email, :phone, :type
    def initialize(params)
      @id = params[:id]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      @email = params[:email]
      @phone = params[:phone]
      @type = params[:type]
    end
  end
end

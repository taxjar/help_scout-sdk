# frozen_string_literal: true

module HelpScout
  class Customer < HelpScout::Base
    extend Getable
    extend Listable

    BASIC_ATTRIBUTES = %i[
      first_name
      last_name
      photo_url
      job_title
      photo_type
      background
      location
      created_at
      updated_at
      organization
      gender
      age
      id
    ].freeze
    EMBEDDED_ATTRIBUTES = %i[
      addresses
      chats
      emails
      phones
      social_profiles
      websites
    ].freeze
    attr_reader(*(BASIC_ATTRIBUTES + EMBEDDED_ATTRIBUTES))
    attr_reader :hrefs

    def initialize(params = {})
      BASIC_ATTRIBUTES.each do |attribute|
        next unless params[attribute]

        instance_variable_set("@#{attribute}", params[attribute])
      end

      embedded_params = params.fetch(:_embedded, {})
      EMBEDDED_ATTRIBUTES.each do |attribute|
        next unless embedded_params[attribute]

        instance_variable_set("@#{attribute}", embedded_params[attribute])
      end

      @hrefs = HelpScout::Util.map_links(params[:_links])
    end

    def update_email(email_id, new_email, type: :other)
      email_path = "#{URI.parse(hrefs[:self]).path}/emails/#{email_id}"
      HelpScout.api.put(email_path, { type: type, value: new_email })
      true
    end
  end
end

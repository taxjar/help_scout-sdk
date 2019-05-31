# frozen_string_literal: true

module HelpScout
  module Util
    class << self
      def camelize(term)
        term = term.to_s.split('_').collect(&:capitalize).join
        term[0] = term[0].downcase
        term
      end

      def camelize_keys(source)
        source.each_with_object({}) do |(key, value), results|
          results[camelize(key)] = if value.is_a? Hash
                                     camelize_keys(value)
                                   else
                                     value
                                   end
        end
      end

      def jsonify(term)
        camelize(keyify(term))
      end

      def keyify(term)
        term.to_s.delete('@')
      end

      def map_links(links)
        links.map { |k, v| [k, v[:href]] }.to_h
      end

      def serialized_value(value, type)
        if value.is_a? Array
          value.map { |v| serialized_value(v, type) }
        else
          value.class < HelpScout::Base ? value.send(type) : value
        end
      end
    end
  end
end

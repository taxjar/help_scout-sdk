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

      # def from_json(data)
      #   deep_underscore(::JSON.parse(data))
      # end

      def jsonify(term)
        camelize(keyify(term))
      end

      def keyify(term)
        term.to_s.delete('@')
      end

      def map_links(links)
        links.map { |k, v| [k, v[:href]] }.to_h
      end

      def parse_path(path_template, replacements)
        placeholders = Regexp.union(replacements.keys)
        path_template.gsub(placeholders) { |match_text| replacements[match_text] }
      end

      def serialized_value(value, type)
        if value.is_a? Array
          value.map { |v| serialized_value(v, type) }
        else
          value.class < HelpScout::Base ? value.send(type) : value
        end
      end

      # private

      # def deep_underscore(hash)
      #   hash.map do |k, v|
      #     [
      #       deep_underscore_key(k),
      #       deep_underscore_value(v)
      #     ]
      #   end.to_h
      # end

      # def deep_underscore_key(key)
      #   underscore(key).to_sym
      # end

      # def deep_underscore_value(value)
      #   case value
      #   when Hash
      #     deep_underscore(value)
      #   when Array
      #     if value.any? { |e| e.class < HelpScout::Base }
      #       value.map { |v| deep_underscore(v) }
      #     else
      #       value
      #     end
      #   else
      #     value
      #   end
      # end

      # def underscore(string)
      #   string.gsub(/::/, '/').
      #     gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      #     gsub(/([a-z\d])([A-Z])/, '\1_\2').
      #     tr('-', '_').
      #     downcase
      # end
    end
  end
end

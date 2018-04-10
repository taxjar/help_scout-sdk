# frozen_string_literal: true

module Helpscout
  class Base
    # TODO: Test
    def to_h(method = :to_h)
      {}.tap do |result|
        instance_variables.each do |var|
          attribute = { name: var, value: serialized_value(instance_variable_get(var), method) }
          if block_given?
            yield(result, attribute)
          else
            result[keyify(attribute[:name])] = attribute[:value]
          end
        end
      end
    end

    def as_json
      to_h(:as_json) do |result, attribute|
        result[camelize(keyify(attribute[:name]))] = attribute[:value]
      end
    end

    def to_json
      as_json.to_json
    end

    private

    def camelize(term)
      term = term.split('_').collect(&:capitalize).join
      term[0] = term[0].downcase
      term
    end

    def keyify(ivar)
      ivar.to_s.delete('@')
    end

    def serialized_value(value, type)
      if value.is_a? Array
        value.map { |v| serialized_value(v, type) }
      else
        value.class < Helpscout::Base ? value.send(type) : value
      end
    end
  end
end

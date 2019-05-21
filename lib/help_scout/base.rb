# frozen_string_literal: true

module HelpScout
  class Base
    # TODO: Test
    def to_h(method = :to_h)
      {}.tap do |result|
        instance_variables.each do |var|
          attribute = {
            name: var,
            value: HelpScout::Util.serialized_value(instance_variable_get(var), method)
          }
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
        result[HelpScout::Util.jsonify(attribute[:name])] = attribute[:value]
      end
    end

    def to_json(*_args)
      as_json.to_json
    end
  end
end

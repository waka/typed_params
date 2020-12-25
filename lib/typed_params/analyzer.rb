require "action_controller"

module TypedParams
  class Analyzer
    def self.diff(parameters, class_name)
      hash = hash_from_params(parameters)
      return parameters if hash.nil?

      namespace = create_namespace(class_name)
      typings = TypedParams::Environment.typings_from_namespace(namespace)

      type_diff(hash, typings)
    end

    def self.create_namespace(class_name)
      parts = class_name.to_s.split('::').map(&:to_sym)
      { name: parts[-1], paths: parts[0...-1] }
    end

    def self.hash_from_params(parameters)
      case parameters
      when ActionController::Parameters
        parameters.to_unsafe_hash.deep_symbolize_keys
      when Hash, ActiveSupport::HashWithIndifferentAccess
        parameters.deep_symbolize_keys
      else
        nil
      end
    end

    def self.type_diff(hash, typings)
      diff = hash.map { |k, v|
        typing = typings[k]
        if v.class == Hash
          [k, type_diff(v, typing)]
        elsif v.class.name.to_sym == typing
          [k, nil]
        else
          [k, "Invalid type: expected=#{typing}, actual=#{v.class.name.to_sym}"]
        end
      }.to_h.compact
      diff.empty? ? nil : diff
    end
  end
end

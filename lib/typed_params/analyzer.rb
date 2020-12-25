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
        elsif typing.nil?
          [k, "Invalid type: #{k} is not found in rbs file."]
        else
          [k, "Invalid type: #{k} expected=#{typing}, actual=#{v.class.name.to_sym}"]
        end
      }.to_h.compact

      deletions = (typings.keys - hash.keys).map { |k|
        [k, "Invalid type: #{k} is not found in parameters"]
      }.to_h
      diff.merge!(deletions) unless deletions.empty?

      diff.empty? ? nil : diff
    end
  end
end

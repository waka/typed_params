require "action_controller"

module TypedParams
  class Analyzer
    def self.check_type(parameters, type)
      struct = 
        case parameters
        when ActionController::Parameters
          struct_from_params(parameters)
        when Hash, ActiveSupport::HashWithIndifferentAccess
          struct_from_hash(parameters)
        else
          nil
        end
      return parameters if struct.nil?

      same_structure?(
        Environment.structure_from_struct(struct),
        Environment.structure_from_type(type)
      )
    end

    # @param [ActionController::Parameters] parameters
    def self.struct_from_params(parameters)
      struct_from_hash(parameters.to_unsafe_hash.deep_symbolize_keys)
    end

    # @param [Hash | ActiveSupport::HashWithIndifferentAccess] hash
    def self.struct_from_hash(hash)
      values = hash.values.map do |v|
        case v
        when Hash, ActiveSupport::HashWithIndifferentAccess
          struct_from_hash(v)
        when Array
          v.map {|x| struct_from_hash(x) }
        else
          v
        end
      end
      Struct.new(*hash.keys).new(*values)
    end
  end
end

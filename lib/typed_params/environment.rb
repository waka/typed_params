require 'rbs'

module TypedParams
  class Environment
    # namespace: { name: :CreateRequest, paths: [:UsersController] }
    def self.typings_from_namespace(namespace)
      instance = definition_instance(namespace)

      # key and type
      kv_pairs = instance.instance_variables.map do |key, value|
        k = key.to_s.delete("@").to_sym
        name = value.type.name
        if name.namespace.path.size == 0
          [k, name.name]
        else
          [
            k,
            typings_from_namespace({ name: name.name, paths: name.namespace.path })
          ]
        end
      end
      kv_pairs.to_h
    end

    def self.definition_instance(namespace)
      named_type = type_name(namespace[:name], namespace[:paths])
      definition_builder.build_instance(named_type)
    end

    def self.type_name(name, paths)
      RBS::TypeName.new(
        name: name,
        namespace: RBS::Namespace.new(absolute: true, path: paths)
      )
    end

    def self.definition_builder
      return @builder if @builder
      rbs_env = load_rbs_env
      @builder = RBS::DefinitionBuilder.new(env: rbs_env)
    end

    def self.load_rbs_env
      loader = RBS::EnvironmentLoader.new
      loader.add(path: TypedParams.config.sig_path)
      RBS::Environment.from_loader(loader).resolve_type_names
    end
  end
end

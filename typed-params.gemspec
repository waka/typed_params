require_relative 'lib/typed_params/version'

Gem::Specification.new do |spec|
  spec.name          = "typed-params"
  spec.version       = TypedParams::VERSION
  spec.authors       = ["yo_waka"]
  spec.email         = ["y.wakahara@gmail.com"]

  spec.summary       = "Handle typed request parameter."
  spec.description   = "Handle typed request parameter."
  spec.homepage      = "https://github.com/waka/typed_params"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'actionpack', '>= 6.0'
  spec.add_dependency 'rbs', '>= 0.20'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.6.1'
  spec.add_development_dependency 'sqlite3'
end
